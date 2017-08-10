{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 *}
{assign var=articlePath value=$article->getBestArticleId()}
{assign var=journalPath value=$journal->getPath()}


{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

<div class="obj_article_summary">
	{if $article->getLocalizedCoverImage()}
		<div class="cover">
			<a href="{url journal=$journalPath page="article" op="view" path=$articlePath}" target="_new" class="file">
				<img src="{$coverImagePath|escape}{$article->getLocalizedCoverImage()|escape}"{if $article->getLocalizedCoverImageAltText() != ''} alt="{$article->getLocalizedCoverImageAltText()|escape}"{else} alt="{translate key="article.coverPage.altText"}"{/if}>
			</a>
		</div>
	{/if}

	<div class="title">
		<a href="{url journal=$journalPath page="article" op="view" path=$articlePath}" target="_new">
			{$article->getLocalizedTitle()|strip_unsafe_html}
		</a>
	</div>

	{if $showAuthor || $article->getPages() || ($article->getDatePublished() && $showDatePublished)}
	<div class="meta">
		{if $showAuthor}
		<div class="authors">
			{$article->getAuthorString()} / {$journal->getLocalizedName()}
		</div>
		{/if}
	</div>
	{/if}

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
