<?php

/**
 * @defgroup plugins_themes_tsvsite tsvSite theme plugin
 */
 
/**
 * @file plugins/themes/tsvSite/index.php
 *
 * Copyright (c) 2014-2018 Simon Fraser University Library
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_themes_tsvsite
 * @brief Wrapper for tsvSite theme plugin.
 *
 */

require_once('TsvSiteThemePlugin.inc.php');

return new TsvSiteThemePlugin();

?>
