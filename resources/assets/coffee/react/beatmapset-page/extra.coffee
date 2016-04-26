###
# Copyright 2016 ppy Pty. Ltd.
#
# This file is part of osu!web. osu!web is distributed with the hope of
# attracting more community contributions to the core ecosystem of osu!.
#
# osu!web is free software: you can redistribute it and/or modify
# it under the terms of the Affero GNU General Public License version 3
# as published by the Free Software Foundation.
#
# osu!web is distributed WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with osu!web.  If not, see <http://www.gnu.org/licenses/>.
###
{div} = React.DOM
el = React.createElement

class BeatmapSetPage.Extra extends StickyTabsPage
  constructor: (props) ->
    super props

    @state =
      tabsSticky: false


  componentDidMount: ->
    @_removeListeners()
    $.subscribe 'stickyHeader.beatmapSetPageExtra', @_tabsStick


  componentWillUnmount: ->
    @_removeListeners()


  _removeListeners: ->
    $.unsubscribe '.beatmapSetPageExtra'
    $(window).off '.beatmapSetPageExtra'


  elements = ['description', 'success-rate', 'scoreboard']

  render: ->
    tabs = div className: 'hidden-xs page-extra-tabs__container',
      div className: 'osu-layout__row',
        div className: 'page-extra-tabs__items',
          elements.map (m) =>
            el BeatmapSetPage.ExtraTab, key: m, page: m, currentPage: @props.currentPage, currentMode: @props.currentMode

    div className: 'osu-layout__section osu-layout__section--extra',
      div
        className: 'page-extra-tabs js-sticky-header js-switchable-mode-page--scrollspy-offset'
        'data-sticky-header-target': 'page-extra-tabs'
        tabs

      div
        className: 'page-extra-tabs page-extra-tabs--fixed'
        'data-visibility': if @state.tabsSticky then '' else 'hidden'
        tabs

      div className: 'osu-layout__row',
        elements.map (m) =>
          elem =
            switch m
              when 'description'
                props = description: @props.set.description
                BeatmapSetPage.Description
              when 'success-rate'
                props =
                  beatmap: @props.beatmap
                  failtimes: @props.beatmap.failtimes.data
                BeatmapSetPage.SuccessRate
              when 'scoreboard'
                props =
                  currentScoreboard: @props.currentScoreboard
                  scores: @props.scores
                  countries: @props.countries
                BeatmapSetPage.Scoreboard

          div
            className: 'js-switchable-mode-page--scrollspy js-switchable-mode-page--page'
            key: m
            'data-page-id': m
            el elem, props
