{**
 * templates/frontend/components/searchForm_simple.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Simple display of a search form with just text input and search button
 *
 * @uses $searchQuery string Previously input search query
 *}
 
 
	<div class="tsv_search">
 	<form action="{url page="search" op="search"}" method="post" autocomplete="off" role="search">
		{csrf}
		
			<input type="text" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="plugins.themes.tsvSite.search"}"><button class="submit" type="submit"><span class="fa fa-search"></span></button>
		
	</form>
	</div>