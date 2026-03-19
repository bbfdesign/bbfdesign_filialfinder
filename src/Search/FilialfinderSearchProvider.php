<?php

declare(strict_types=1);

namespace Plugin\bbfdesign_filialfinder\src\Search;

use BbfdesignSearch\API\SearchContentProvider;
use JTL\Plugin\PluginInterface;
use JTL\Shop;

/**
 * BBF Suche integration for the Filialfinder plugin.
 *
 * Provides branch data to Meilisearch via the bbfdesign_search plugin.
 * Branches are indexed with their name, address, contact info, and
 * geographic coordinates for search and filtering.
 */
class FilialfinderSearchProvider implements SearchContentProvider
{
    /**
     * @param PluginInterface $plugin The plugin instance
     */
    public function __construct(
        private readonly PluginInterface $plugin
    ) {
    }

    /**
     * Get the content type identifier.
     *
     * @return string
     */
    public function getType(): string
    {
        return 'filialfinder';
    }

    /**
     * Get the human-readable name for this content type.
     *
     * @return string
     */
    public function getName(): string
    {
        return 'Filialen / Standorte';
    }

    /**
     * Get the label for admin UI display.
     *
     * @return string
     */
    public function getLabel(): string
    {
        return 'Filialfinder';
    }

    /**
     * Check whether this content provider is enabled.
     *
     * @return bool
     */
    public function isEnabled(): bool
    {
        return true;
    }

    /**
     * Get searchable documents (branches) for indexing.
     *
     * Returns active branches as structured documents suitable for
     * Meilisearch indexing, including title, description, content,
     * and metadata fields.
     *
     * @param string $lang   Language code (default: 'de')
     * @param int    $offset Pagination offset
     * @param int    $limit  Maximum number of documents to return
     * @return array<int, array<string, mixed>>
     */
    public function getDocuments(string $lang = 'de', int $offset = 0, int $limit = 100): array
    {
        $db = Shop::Container()->getDB();
        $branches = $db->queryPrepared(
            "SELECT * FROM `bbf_filialfinder_branch` WHERE `is_active` = 1 ORDER BY `sort_order` ASC LIMIT :offset, :lim",
            ['offset' => $offset, 'lim' => $limit],
            2
        );

        if (!is_array($branches)) {
            return [];
        }

        $documents = [];
        foreach ($branches as $branch) {
            $documents[] = [
                'id'          => 'filiale_' . $branch->id . '_' . $lang,
                'type'        => 'filialfinder',
                'title'       => (string)$branch->name,
                'description' => strip_tags((string)($branch->description_html ?? $branch->description ?? '')),
                'content'     => implode(' ', array_filter([
                    $branch->name ?? '',
                    $branch->street ?? '',
                    $branch->zip ?? '',
                    $branch->city ?? '',
                    $branch->phone ?? '',
                    $branch->email ?? '',
                ])),
                'url'         => '',
                'image'       => (string)($branch->image_path ?? ''),
                'meta'        => [
                    'branch_id' => (int)$branch->id,
                    'city'      => (string)($branch->city ?? ''),
                    'zip'       => (string)($branch->zip ?? ''),
                    'phone'     => (string)($branch->phone ?? ''),
                    'lat'       => (float)($branch->latitude ?? 0),
                    'lng'       => (float)($branch->longitude ?? 0),
                ],
            ];
        }

        return $documents;
    }

    /**
     * Get the total count of active branches.
     *
     * @param string $lang Language code (default: 'de')
     * @return int
     */
    public function getTotalCount(string $lang = 'de'): int
    {
        $db = Shop::Container()->getDB();
        $row = $db->queryPrepared(
            "SELECT COUNT(*) as cnt FROM `bbf_filialfinder_branch` WHERE `is_active` = 1",
            [],
            1
        );

        return (int)($row->cnt ?? 0);
    }

    /**
     * Get the list of attributes that should be searchable in Meilisearch.
     *
     * @return string[]
     */
    public function getSearchableAttributes(): array
    {
        return ['title', 'description', 'content'];
    }

    /**
     * Get the list of attributes that should be filterable in Meilisearch.
     *
     * @return string[]
     */
    public function getFilterableAttributes(): array
    {
        return ['type', 'meta.city', 'meta.zip'];
    }

    /**
     * Get the list of attributes that should be sortable in Meilisearch.
     *
     * @return string[]
     */
    public function getSortableAttributes(): array
    {
        return ['title'];
    }
}
