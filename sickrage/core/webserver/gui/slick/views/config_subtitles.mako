<%inherit file="/layouts/main.mako"/>
<%!
    import sickrage
    from core.searchers import subtitle_searcher
    from core.helpers import anon_url
%>
<%block name="scripts">
<script type="text/javascript" src="${srRoot}/js/configSubtitles.js?${srPID}"></script>
<script type="text/javascript" src="${srRoot}/js/config.js"></script>
<script>
$(document).ready(function() {
    $("#subtitles_languages").tokenInput([${','.join("{\"id\": \"" + lang.opensubtitles + "\", name: \"" + lang.name + "\"}" for lang in subtitle_searcher.subtitleLanguageFilter())}], {
        method: "POST",
        hintText: "Write to search a language and select it",
        preventDuplicates: true,
        prePopulate: [${','.join("{\"id\": \"" + subtitle_searcher.fromietf(lang).opensubtitles + "\", name: \"" + subtitle_searcher.fromietf(lang).name + "\"}" for lang in subtitle_searcher.wantedLanguages()) if subtitle_searcher.wantedLanguages() else ''}]
    });
});
$('#config-components').tabs();
$('#subtitles_dir').fileBrowser({ title: 'Select Subtitles Download Directory' });
</script>
</%block>
<%block name="content">
% if not header is UNDEFINED:
    <h1 class="header">${header}</h1>
% else:
    <h1 class="title">${title}</h1>
% endif

<div id="config">
<div id="config-content">

<form id="configForm" action="saveSubtitles" method="post">

            <div id="config-components">
                <ul>
                    <li><a href="#core-component-group1">Subtitles Search</a></li>
                    <li><a href="#core-component-group2">Subtitles Plugin</a></li>
                    <li><a href="#core-component-group3">Plugin Settings</a></li>
                </ul>

                <div id="core-component-group1" class="component-group">

                    <div class="component-group-desc">
                        <h3>Subtitles Search</h3>
                        <p>Settings that dictate how SickRage handles subtitles search results.</p>
                    </div>

                    <fieldset class="component-group-list">
                        <div class="field-pair">
                            <label for="use_subtitles" class="clearfix">
                                <span class="component-title">Search Subtitles</span>
                                <span class="component-desc">
                                    <input type="checkbox"
                                           class="enabler" ${('', ' checked="checked"')[bool(sickrage.srConfig.USE_SUBTITLES)]}
                                           id="use_subtitles" name="use_subtitles">
                                </span>
                            </label>
                        </div>
                        <div id="content_use_subtitles">
                                <div class="field-pair">
                                    <label>
                                        <span class="component-title">Subtitle Languages</span>
                                        <span class="component-desc"><input type="text" id="subtitles_languages" name="subtitles_languages" autocapitalize="off" /></span>
                                    </label>
                                </div>
                                <div class="field-pair">
                                    <label>
                                        <span class="component-title">Subtitle Directory</span>
                                        <input type="text" value="${sickrage.srConfig.SUBTITLES_DIR}" id="subtitles_dir"
                                               name="subtitles_dir" class="form-control input-sm input350"
                                               autocapitalize="off"/>
                                    </label>
                                    <label>
                                            <span class="component-title">&nbsp;</span>
                                            <span class="component-desc">The directory where SickRage should store your <i>Subtitles</i> files.</span>
                                      </label>
                                    <label>
                                            <span class="component-title">&nbsp;</span>
                                            <span class="component-desc"><b>NOTE:</b> Leave empty if you want store subtitle in episode path.</span>
                                      </label>
                                </div>
                                <div class="field-pair">
                                    <label>
                                        <span class="component-title">Subtitle Find Frequency</span>
                                        <input type="number" name="subtitles_finder_frequency"
                                               value="${sickrage.srConfig.SUBTITLE_SEARCHER_FREQ}" hours="1"
                                               class="form-control input-sm input75"/>
                                        <span class="component-desc">time in hours between scans (default: 1)</span>
                                    </label>
                                </div>
                                <div class="field-pair">
                                    <label class="clearfix" for="subtitles_history">
                                        <span class="component-title">Subtitles History</span>
                                        <span class="component-desc">
                                            <input type="checkbox" name="subtitles_history"
                                                   id="subtitles_history" ${('', 'checked="checked"')[bool(sickrage.srConfig.SUBTITLES_HISTORY)]}/>
                                            <p>Log downloaded Subtitle on History page?</p>
                                        </span>
                                    </label>
                                </div>
                                <div class="field-pair">
                                    <label class="clearfix" for="subtitles_multi">
                                        <span class="component-title">Subtitles Multi-Language</span>
                                        <span class="component-desc">
                                            <input type="checkbox" name="subtitles_multi"
                                                   id="subtitles_multi" ${('', 'checked="checked"')[bool(sickrage.srConfig.SUBTITLES_MULTI)]}/>
                                            <p>Append language codes to subtitle filenames?</p>
                                        </span>
                                    </label>
                                </div>
                                <div class="field-pair">
                                    <label class="clearfix" for="embedded_subtitles_all">
                                        <span class="component-title">Embedded Subtitles</span>
                                        <span class="component-desc">
                                            <input type="checkbox" name="embedded_subtitles_all"
                                                   id="embedded_subtitles_all" ${('', 'checked="checked"')[bool(sickrage.srConfig.EMBEDDED_SUBTITLES_ALL)]}/>
                                            <p>Ignore subtitles embedded inside video file?</p>
                                            <p><b>Warning: </b>this will ignore <u>all</u> embedded subtitles for every video file!</p>
                                        </span>
                                    </label>
                                </div>
                                <div class="field-pair">
                                    <label class="clearfix" for="subtitles_hearing_impaired">
                                        <span class="component-title">Hearing Impaired Subtitles</span>
                                        <span class="component-desc">
                                            <input type="checkbox" name="subtitles_hearing_impaired"
                                                   id="subtitles_hearing_impaired" ${('', 'checked="checked"')[bool(sickrage.srConfig.SUBTITLES_HEARING_IMPAIRED)]}/>
                                            <p>Download hearing impaired style subtitles?</p>
                                        </span>
                                    </label>
                                </div>
                                <div class="field-pair">
                                    <label class="nocheck">
                                        <span class="component-title">Extra Scripts</span>
                                        <input type="text" name="subtitles_extra_scripts"
                                               value="<% '|'.join(sickrage.srConfig.SUBTITLES_EXTRA_SCRIPTS) %>"
                                               class="form-control input-sm input350" autocapitalize="off"/>
                                    </label>
                                    <label class="nocheck">
                                        <span class="component-title">&nbsp;</span>
                                        <span class="component-desc"><b>NOTE:</b></span>
                                    </label>
                                    <label class="nocheck">
                                        <span class="component-title">&nbsp;</span>
                                        <span class="component-desc">
                                            <ul>
                                                    <li>See <a href="https://github.com/SiCKRAGETV/SiCKRAGE/wiki/Subtitle%20Scripts"><font color='red'><b>Wiki</b></font></a> for a script arguments description.</li>
                                                    <li>Additional scripts separated by <b>|</b>.</li>
                                                    <li>Scripts are called after each episode has searched and downloaded subtitles.</li>
                                                    <li>For any scripted languages, include the interpreter executable before the script. See the following example:</li>
                                                    <ul>
                                                        <li>For Windows: <pre>C:\Python27\pythonw.exe C:\Script\test.py</pre></li>
                                                        <li>For Linux: <pre>python /Script/test.py</pre></li>
                                                    </ul>
                                            </ul>
                                        </span>
                                    </label>
                                </div>

                        <br><input type="submit" class="btn config_submitter" value="Save Changes" /><br>
                        </div>
                    </fieldset>
                </div><!-- /component-group1 //-->

                <div id="core-component-group2" class="component-group">

                    <div class="component-group-desc">
                        <h3>Subtitle Plugins</h3>
                        <p>Check off and drag the plugins into the order you want them to be used.</p>
                        <p class="note">At least one plugin is required.</p>
                        <p class="note"><span style="font-size: 16px;">*</span> Web-scraping plugin</p>
                    </div>

                    <fieldset class="component-group-list" style="margin-left: 50px; margin-top:36px">
                        <ul id="service_order_list">
                            % for curService in subtitle_searcher.sortedServiceList():
                            <li class="ui-state-default" id="${curService[b'name']}">
                                <input type="checkbox" id="enable_${curService[b'name']}" class="service_enabler" ${('', 'checked="checked"')[curService[b'enabled'] == True]}/>
                                <a href="${anon_url(curService[b'url'])}" class="imgLink" target="_new">
                                    <img src="${srRoot}/images/subtitles/${curService[b'image']}" alt="${curService[b'url']}" title="${curService[b'url']}" width="16" height="16" style="vertical-align:middle;"/>
                                </a>
                            <span style="vertical-align:middle;">${curService[b'name'].capitalize()}</span>
                            <span class="ui-icon ui-icon-arrowthick-2-n-s pull-right" style="vertical-align:middle;"></span>
                          </li>
                        % endfor
                        </ul>
                        <input type="hidden" name="service_order" id="service_order"
                               value="<% ''.join(['%s:%d' % (x[b'name'], x[b'enabled']) for x in subtitle_searcher.sortedServiceList()])%>"/>

                        <br><input type="submit" class="btn config_submitter" value="Save Changes" /><br>
                    </fieldset>
                </div><!-- /component-group2 //-->
                <div id="core-component-group3" class="component-group">
                    <div class="component-group-desc">
                        <h3>Subtitle Settings</h3>
                        <p>Set user and password for each provider</p>
                    </div><!-- /component-group-desc //-->

                    <fieldset class="component-group-list" style="margin-left: 50px; margin-top:36px">
                        <%
                            providerLoginDict = {
                                'legendastv': {'user': sickrage.srConfig.LEGENDASTV_USER, 'pass': sickrage.srConfig.LEGENDASTV_PASS},
                                'addic7ed': {'user': sickrage.srConfig.ADDIC7ED_USER, 'pass': sickrage.srConfig.ADDIC7ED_PASS},
                                'opensubtitles': {'user': sickrage.srConfig.OPENSUBTITLES_USER, 'pass': sickrage.srConfig.OPENSUBTITLES_PASS}}
                        %>
                        % for curService in subtitle_searcher.sortedServiceList():
                        <%
                            if curService[b'name'] not in providerLoginDict.keys():
                                    continue
                        %>
                            ##<div class="field-pair${(' hidden', '')[curService[b'enabled']}"> ## Need js to show/hide on save
                            <div class="field-pair">
                                <label class="nocheck" for="${curService[b'name']}_user">
                                    <span class="component-title">${curService[b'name'].capitalize()} User Name</span>
                                    <span class="component-desc">
                                        <input type="text" name="${curService[b'name']}_user" id="${curService[b'name']}_user" value="${providerLoginDict[curService[b'name']][b'user']}" class="form-control input-sm input300" autocapitalize="off" />
                                    </span>
                                </label>
                                <label class="nocheck" for="${curService[b'name']}_pass">
                                    <span class="component-title">${curService[b'name'].capitalize()} Password</span>
                                    <span class="component-desc">
                                        <input type="password" name="${curService[b'name']}_pass" id="${curService[b'name']}_pass" value="${providerLoginDict[curService[b'name']][b'pass']}" class="form-control input-sm input300" autocapitalize="off" />
                                    </span>
                                </label>
                            </div>
                        % endfor
                        <br><input type="submit" class="btn config_submitter" value="Save Changes" /><br>
                    </fieldset>
                </div><!-- /component-group3 //-->
            </div><!-- /config-components //-->

</form>
</div>
</div>

<div class="clearfix"></div>
</%block>