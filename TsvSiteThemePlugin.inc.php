<?php

/**
 * @file plugins/themes/tsvSite/DefaultThemePlugin.inc.php
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class TsvSiteThemePlugin
 * @ingroup plugins_themes_tsvsite
 *
 * @brief TsvSite theme
 */

import('lib.pkp.classes.plugins.ThemePlugin');

class TsvSiteThemePlugin extends ThemePlugin {
	/**
	 * @copydoc ThemePlugin::isActive()
	 */
	public function isActive() {
		if (defined('SESSION_DISABLE_INIT')) return true;
		return parent::isActive();
	}

	/**
	 * Initialize the theme's styles, scripts and hooks. This is run on the
	 * currently active theme and it's parent themes.
	 *
	 * @return null
	 */
	public function init() {

		// Load language selection
		HookRegistry::register ('TemplateManager::display', array($this, 'loadTemplateData'));

		// Load primary stylesheet
		$this->addStyle('stylesheet', 'styles/index.less');

		// Store additional LESS variables to process based on options
		$additionalLessVariables = array();
		
		$this->addStyle(
					'fontMuli',
					'//fonts.googleapis.com/css?family=Muli:300,300i,400,600,700,700i,900',
					array('baseUrl' => '')
				);
				
		$additionalLessVariables[] = '@font: "Muli", sans-serif;@font-heading: Muli, sans-serif;';		
		
		
		// Pass additional LESS variables based on options
		if (!empty($additionalLessVariables)) {
			$this->modifyStyle('stylesheet', array('addLessVariables' => join($additionalLessVariables)));
		}		
		
		// Load icon font FontAwesome - http://fontawesome.io/
		if (Config::getVar('general', 'enable_cdn')) {
			$url = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css';
		} else {
			$url = $request->getBaseUrl() . '/lib/pkp/styles/fontawesome/fontawesome.css';
		}
		$this->addStyle(
			'fontAwesome',
			$url,
			array('baseUrl' => '')
		);		

		// Load jQuery from a CDN or, if CDNs are disabled, from a local copy.
		$min = Config::getVar('general', 'enable_minified') ? '.min' : '';
		$request = Application::getRequest();
		if (Config::getVar('general', 'enable_cdn')) {
			$jquery = '//ajax.googleapis.com/ajax/libs/jquery/' . CDN_JQUERY_VERSION . '/jquery' . $min . '.js';
			$jqueryUI = '//ajax.googleapis.com/ajax/libs/jqueryui/' . CDN_JQUERY_UI_VERSION . '/jquery-ui' . $min . '.js';
		} else {
			// Use OJS's built-in jQuery files
			$jquery = $request->getBaseUrl() . '/lib/pkp/lib/components/jquery/jquery' . $min . '.js';
			$jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/components/jquery-ui/jquery-ui' . $min . '.js';
		}
		// Use an empty `baseUrl` argument to prevent the theme from looking for
		// the files within the theme directory
		$this->addScript('jQuery', $jquery, array('baseUrl' => ''));
		$this->addScript('jQueryUI', $jqueryUI, array('baseUrl' => ''));
		$this->addScript('jQueryTagIt', $request->getBaseUrl() . '/lib/pkp/js/lib/jquery/plugins/jquery.tag-it.js', array('baseUrl' => ''));

		// Load custom JavaScript for this theme
		$this->addScript('default', 'js/main.js');
		$this->addScript('isotope', 'js/isotope.js');
		$this->addScript('loadisotope', 'js/loadisotope.js');
	}


	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return __('plugins.themes.tsvSite.name');
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return __('plugins.themes.tsvSite.description');
	}
	
	/**
	 * Get the HTML contents for this block.
	 * @param $templateMgr object
	 * @param $request PKPRequest
	 */
	public function loadTemplateData($hookName, $args) {		
		$templateMgr = $args[0];
        $template = $args[1];
		$request = Application::getRequest();
        $site = $request->getSite();
		$issueDao = DAORegistry::getDAO('IssueDAO');
		$journalDao = DAORegistry::getDAO('JournalDAO');
		
		
		// Luettelosta piilotettavat lehdet
		$hideJournals = array(82, 57, 46, 83, 58, 44, 73);
		
		// Hausta piilotettavat lehdet
		$hideFromSearch = array(53, 45, 57, 72, 73, 74, 75, 78, 79, 82, 83, 51, 44);
		
		$templateMgr->assign('hideJournals', $hideJournals);
		$templateMgr->assign('hideFromSearch', $hideFromSearch);
		
		// Start Language selector
		$templateMgr->assign('isPostRequest', $request->isPost());	
		
		if (!defined('SESSION_DISABLE_INIT')) {
			$locales = $site->getSupportedLocales();
		} else {
			$locales = AppLocale::getAllLocales();
			$templateMgr->assign('languageToggleNoUser', true);
		}
		if (isset($locales) && count($locales) > 1) {
			$templateMgr->assign('enableLanguageToggle', false);
			$templateMgr->assign('languageToggleLocales', $locales);
			
			
		}
		// End Language selector

		
		
		// Start Latest issues
		$issues = array();
		$issueList = array();
		$volLabel = __('issue.vol');
		$numLabel = __('issue.no');
		
		$result = $issueDao->retrieve("SELECT issue_id FROM issues WHERE published = '1' AND access_status= '1' AND year != '0' AND journal_id NOT IN (53, 42, 45, 57, 71, 72, 73, 74, 75, 76, 78, 79, 82, 83, 51, 58, 44, 90, 91, 92, 94, 95, 96, 97, 67, 113) ORDER BY date_published DESC LIMIT 6");
		
		while (!$result->EOF) {
			$resultRow = $result->GetRowAssoc(false);
			$issues[$resultRow['issue_id']] = $issueDao->getById($resultRow['issue_id']);
			$result->MoveNext();
		}
		$result->Close();

		foreach($issues as $issueId => $issue){
			
			$journal = $journalDao->getById($issue->getJournalId());
			$issueList[$issueId]['journal'] = $journal->getLocalizedName();
			$issueList[$issueId]['journalPath'] = $journal->getPath();
			
			if ($issue->getLocalizedCoverImageUrl()){
				$issueList[$issueId]['cover'] =  $issue->getLocalizedCoverImageUrl();
				$issueList[$issueId]['contain'] =  true;
			}	
			# Tähän listauskannen haku toiseksi vaihtoehdoksi, vasta sen jälkeen haetaan tuo viimeinen vaihtoehto
			else{
				$issueList[$issueId]['cover'] =  $request->getBaseUrl()."/plugins/themes/tsvSite/images/journalfi_default_cover.png";
			}
			
			
			$issueList[$issueId]['path'] =  $issue->getBestIssueId();
			
			$volume = $issue->getVolume();
			$number = $issue->getNumber();
			$year = $issue->getyear();
			
			$issueIdentification = "";
			if ($year != "") $issueIdentification = "(".$year.")".$issueIdentification;
			if ($number != "0") $issueIdentification = $numLabel." ".$number." ".$issueIdentification;
			if ($volume != "0") $issueIdentification = $volLabel." ".$volume." ".$issueIdentification;		
			
			$issueList[$issueId]['identification'] =  $issueIdentification;
			
			
			
		}
		$templateMgr->assign('issueList', $issueList);
		
		// End Latest issues
		
		
		// Start Most read
		$metricsDao = DAORegistry::getDAO('MetricsDAO');
		$cacheManager =& CacheManager::getManager();
		$cache  =& $cacheManager->getCache('mostread', 0, array($this, '_cacheMiss'));

		$daysToStale = 1;
		$cachedMetrics = false;
		
		if (time() - $cache->getCacheTime() > 60 * 60 * 24 * $daysToStale) {
			$cachedMetrics = $cache->getContents();
			$cache->flush();
		}
		$resultMetrics = $cache->getContents();
		
		if (!$resultMetrics && $cachedMetrics) {
			$resultMetrics = $cachedMetrics;
			$cache->setEntireCache($cachedMetrics);
		} elseif (!$resultMetrics) {
			$cache->flush();
		}
		
		$templateMgr->assign('resultMetrics', $resultMetrics);
		
		// End Most read		

		

	}

	function _cacheMiss($cache) {
			$metricsDao = DAORegistry::getDAO('MetricsDAO');
			$publishedArticleDao = DAORegistry::getDAO('PublishedArticleDAO');
			$journalDao = DAORegistry::getDAO('JournalDAO');
			
			$result = $metricsDao->retrieve("SELECT submission_id, SUM(metric) AS metric FROM metrics WHERE (day BETWEEN CURDATE()-INTERVAL 1 WEEK AND CURDATE()) AND (assoc_type='515' AND submission_id IS NOT NULL) GROUP BY submission_id ORDER BY metric DESC LIMIT 5");
			
			while (!$result->EOF) {
				$resultRow = $result->GetRowAssoc(false);
				$article = $publishedArticleDao->getById($resultRow['submission_id']);	
				$journal = $journalDao->getById($article->getJournalId());
				$articles[$resultRow['submission_id']]['journalPath'] = $journal->getPath();
				$articles[$resultRow['submission_id']]['journalName'] = $journal->getLocalizedName();
				$articles[$resultRow['submission_id']]['articleId'] = $article->getBestArticleId();
				$articles[$resultRow['submission_id']]['articleTitle'] = $article->getLocalizedTitle();
				$articles[$resultRow['submission_id']]['metric'] = $resultRow['metric'];
				
				$result->MoveNext();
			}
			$result->Close();			
			$cache->setEntireCache($articles);
			return $result;
	}
	
	
	
	
	
}

?>
