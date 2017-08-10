<?php

/**
 * @defgroup plugins_themes_tsvsite tsvSite theme plugin
 */
 
/**
 * @file plugins/themes/tsvSite/index.php
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_themes_tsvsite
 * @brief Wrapper for default theme plugin.
 *
 */

require_once('TsvSiteThemePlugin.inc.php');

return new TsvSiteThemePlugin();

?>
