{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Site index.
 *
 *}
{include file="frontend/components/header.tpl"}

<div class="page_index_site">
	
	
	<h2>{translate|escape key="plugins.themes.tsvSite.recentIssues"}</h2>
	
	<div class="tsv_issues">
	{foreach from=$issueList item=issue}
	
		<div class="tsv_issue hvr-float">
			<a href="{url journal=$issue.journalPath page="issue" op="view" path=$issue.path}">
			<div class="tsv_issue_cover" style="background-image: url({$issue.cover}); {if $issue.contain}background-size: contain;{/if}"></div>
			<div class="tsv_issue_title">{$issue.journal}</div>
			<div class="tsv_issue_issue">{$issue.identification}</div>
			</a>
		</div>
		
	{/foreach}	
	</div>


	
	<div class="tsv_info">
		
		<div class="tsv_info_box">
			<h2>{translate|escape key="plugins.themes.tsvSite.mostRead"}</h2>
			
			<ul class="tsv_most_read">
			{foreach from=$resultMetrics item=article}
				<li class="tsv_most_read_article">
					<div class="tsv_most_read_article_title"><a href="{url journal=$article.journalPath page="article" op="view" path=$article.articleId}">{$article.articleTitle}</a></div>
					<div class="tsv_most_read_article_journal"><span class="fa fa-eye"></span> {$article.metric} | {$article.journalName}</div>
				</li>
			{/foreach}	
			</ul>
			<span style="font-size: 0.8em;"><span class="fa fa-eye"> {translate|escape key="plugins.themes.tsvSite.viewsDescription"}</span>
		</div>
		
		<div class="tsv_info_box">
			<h2>{translate|escape key="plugins.themes.tsvSite.about"}</h2>
			{$about}
		</div>
	
	</div>
	
	<h2>{translate key="journal.journals"}</h2>

	<div class="tsv_journals">
			<div class="grid">
				{iterate from=journals item=journal}
					
					{capture assign="url"}{url journal=$journal->getPath()}{/capture}
					{assign var="thumb" value=$journal->getLocalizedSetting('journalThumbnail')}
					
					<div class="tsv_thumb hvr-float">
						
							<a href="{$url|escape}">
							{if $thumb}
								<div class="tsv_thumb_journal" style="background-image: url({$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"})"></div>
							{else}
								<div class="tsv_thumb_default" style="background-image: url({$baseUrl}/plugins/themes/tsvSite/images/journalfi_default_cover.png)"></div>
							{/if}
							</a>
						
						<div class="tsv_thumb_title"><a href="{$url|escape}" rel="bookmark">{$journal->getLocalizedName()}</a></div>
					
						
					</div>
					
					{/if}
					
				{/iterate}
			</div>
	</div>

</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
