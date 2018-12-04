{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">

{translate|assign:"pageTitleTranslated" key="plugins.themes.tsvSite.title"}
{include file="frontend/components/headerHead.tpl"}


<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}">

	<div class="cmp_skip_to_content">
		<a href="#pkp_content_main">{translate key="navigation.skip.main"}</a>
		<a href="#pkp_content_nav">{translate key="navigation.skip.nav"}</a>
		<a href="#pkp_content_footer">{translate key="navigation.skip.footer"}</a>
	</div>
	<div class="pkp_structure_page">
	
	<!-- Tämä on parent -->

		{* Header *}
		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">				

			<div class="pkp_head_wrapper">

			<nav class="pkp_navigation_user_wrapper navDropdownMenu" id="navigationUserWrapper" aria-label="{translate|escape key="common.navigation.user"}">
					<ul id="navigationUser" class="pkp_navigation_user pkp_nav_list">
					
						{if $isUserLoggedIn}
							<li class="profile {if $unreadNotificationCount} has_tasks{/if}" aria-haspopup="true" aria-expanded="false">
								<a href="{url router=$smarty.const.ROUTE_PAGE page="submissions"}">
									{$loggedInUsername|escape}
									<span class="task_count">
										{$unreadNotificationCount}
									</span>
								</a>
								<ul>
									{if array_intersect(array(ROLE_ID_MANAGER, ROLE_ID_ASSISTANT, ROLE_ID_REVIEWER, ROLE_ID_AUTHOR), (array)$userRoles)}
										<li>
											<a href="{url router=$smarty.const.ROUTE_PAGE page="submissions"}">
												{translate key="navigation.dashboard"}
												<span class="task_count">
													{$unreadNotificationCount}
												</span>
											</a>
										</li>
									{/if}
									<li>
										<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="profile"}">
											{translate key="common.viewProfile"}
										</a>
									</li>
									{if array_intersect(array(ROLE_ID_SITE_ADMIN), (array)$userRoles)}
									<li>
										<a href="{if $multipleContexts}{url router=$smarty.const.ROUTE_PAGE context="index" page="admin" op="index"}{else}{url router=$smarty.const.ROUTE_PAGE page="admin" op="index"}{/if}">
											{translate key="navigation.admin"}
										</a>
									</li>
									{/if}
									<li>
										<a href="{url router=$smarty.const.ROUTE_PAGE page="login" op="signOut"}">
											{translate key="user.logOut"}
										</a>
									</li>
									{if $isUserLoggedInAs}
										<li>
											<a href="{url router=$smarty.const.ROUTE_PAGE page="login" op="signOutAsUser"}">
												{translate key="user.logOutAs"} {$loggedInUsername|escape}
											</a>
										</li>
									{/if}
								</ul>
							</li>
						{else}
							
							<li><a href="{url router=$smarty.const.ROUTE_PAGE page="login"}"><i class="fa fa-sign-out" aria-hidden="true"></i> {translate key="navigation.login"}</a></li>
						{/if}

						{if $enableLanguageToggle}
						<li>
						{foreach from=$languageToggleLocales item=localeName key=localeKey}
						<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeName source=$smarty.server.REQUEST_URI}">
							{$localeName|truncate:2:""}
						</a>
						{/foreach}
						</li>
						{/if}
					</ul>
				</nav><!-- .pkp_navigation_user_wrapper -->			
			
			
				{* Lehden nimi ja logo *}
				<div class="pkp_site_name_wrapper">
		
				
					<h1 class="pkp_site_name">
						{url|assign:"homeUrl" page="index" router=$smarty.const.ROUTE_PAGE}
						
						{if $displayPageHeaderLogo}
						<a href="{$homeUrl}" class="is_img">
						<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{translate key="common.pageHeaderLogo.altText"}"{/if} />		
						</a>
						{/if}
					</h1>

					<div class="pkp_site_name_small">{translate|escape key="plugins.themes.tsvSite.subTitle"}</div>
					
				</div>
				
				
				{include file="frontend/components/searchForm_simple.tpl"}	
				
				

			</div>
		
		</header><!-- .pkp_structure_head -->
		
				
		

		{* Wrapper for page content and sidebars *}
		
		<div class="pkp_structure_content">
		
			<div id="pkp_content_main" class="pkp_structure_main" role="main">

			
			
			
			