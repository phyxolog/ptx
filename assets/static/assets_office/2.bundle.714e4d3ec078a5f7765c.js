webpackJsonp([2],{121:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0;var a=u(n(0)),i=u(n(17)),l=n(4),r=u(n(9));n(128);var d,o=u(n(124)),c=u(n(25)),s=u(n(7)),v=u(n(26)),p=u(n(24)),m=u(n(5));function u(e){return e&&e.__esModule?e:{default:e}}function f(e){return(f="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function b(e,t){for(var n=0;n<t.length;n++){var a=t[n];a.enumerable=a.enumerable||!1,a.configurable=!0,"value"in a&&(a.writable=!0),Object.defineProperty(e,a.key,a)}}function g(e,t){return!t||"object"!==f(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function h(e){return(h=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function k(e,t){return(k=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var w=(0,l.observer)(d=function(e){function t(){var e,n;!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t);for(var l=arguments.length,r=new Array(l),d=0;d<l;d++)r[d]=arguments[d];return(n=g(this,(e=h(t)).call.apply(e,[this].concat(r)))).filters={start_date:void 0,end_date:void 0},n.state={data:void 0,error:!1},n.handleChange=function(e,t){n.filters[t]=e,n.fetchData()},n.fetchData=function(){m.default.isPro&&(n.setState({data:void 0,error:!1}),p.default.links(n.filters).then(function(e){n.setState({data:e})}).catch(function(e){n.setState({error:!0})}))},n.toggle=function(e){e.currentTarget.parentElement.parentElement.classList.toggle("expanded")},n.getRecipient=function(e){return e.split(/[<>]/).map(function(e,t){return 1==t?a.default.createElement("a",{key:t,href:"mailto:".concat(e)},e):e})},n.renderRow=function(e){var t=e.subject,l=e.inserted_at,r=e.links,d=e.recipients,o=arguments.length>1&&void 0!==arguments[1]?arguments[1]:1,c=m.default.user,s=r.length,v=r.filter(function(e){return e.clicks_count>0}).length;return s?a.default.createElement("div",{className:"table-row",key:o},a.default.createElement("div",{className:"cells expandable"},a.default.createElement("div",{className:"expand",onClick:n.toggle},a.default.createElement("img",{src:"/static_office/images/icons/k-arrow-down_black.svg",alt:"expand"})),a.default.createElement("div",{className:"cell wide"},a.default.createElement("div",{className:"cw-content"},a.default.createElement("span",null,t),a.default.createElement("span",null,n.s("LinkTracking.table.links_clicked")," ",v,"/",s)),a.default.createElement("div",{className:"recipients","data-label":n.s("LinkTracking.table.recipients")},d.map(function(e,t){return a.default.createElement("div",{key:t},n.getRecipient(e))}))),a.default.createElement("div",{className:"cell strict"},i.default.output.formatDate(l,c.timezone_offset),a.default.createElement("br",null),a.default.createElement("span",{className:"offset"}),i.default.output.formateTime(l,c.timezone_offset))),a.default.createElement("div",{className:"additional-content"},a.default.createElement("div",{className:"table-row header"},a.default.createElement("div",{className:"cells"},a.default.createElement("div",{className:"cell"},n.s("LinkTracking.table.link")),a.default.createElement("div",{className:"cell strict smaller"},n.s("LinkTracking.table.clicks")))),r.map(function(e,t){return a.default.createElement("div",{className:"table-row",key:t},a.default.createElement("div",{className:"cells"},a.default.createElement("div",{className:"cell"},a.default.createElement("a",{href:e.url,target:"_BLANK"},e.url),e.url!=e.text&&a.default.createElement(a.default.Fragment,null,a.default.createElement("br",null),"(«",e.text,"»)")),a.default.createElement("div",{className:"cell strict smaller"},e.clicks_count)))}))):null},n}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&k(e,t)}(t,s.default),function(e,t,n){t&&b(e.prototype,t),n&&b(e,n)}(t,[{key:"componentDidMount",value:function(){this.fetchData()}},{key:"render",value:function(){var e=this,t=m.default.user;if(!m.default.isPro)return a.default.createElement(v.default,{text:a.default.createElement(a.default.Fragment,null,this.b("errors.pro_only")," ",a.default.createElement("span",{className:"u-pricing-badge pro"}))});var n=this.state,i=n.error,l=n.data;return a.default.createElement("main",{className:"v-email-link-tracking u-fs u-fade-in"},a.default.createElement(r.default,null,a.default.createElement("title",null,this.b("navbar.link_tracking"))),a.default.createElement("h1",null,this.b("navbar.link_tracking")," • ",t.id),a.default.createElement("div",{className:"u-description"},this.b("navbar.stats")," ",this.b("ptc.from"),a.default.createElement(o.default,{onChange:function(t,n){return e.handleChange(n,"start_date")},placeholder:this.b("ptc.start_usage")}),this.b("ptc.to"),a.default.createElement(o.default,{onChange:function(t,n){return e.handleChange(n,"end_date")},placeholder:this.b("ptc.today")})),i?a.default.createElement("div",{className:"lt-error-wrapper u-fade-in fscale"},a.default.createElement("h2",null,this.s("LinkTracking.whoops")),a.default.createElement("p",{className:"u-description"},this.s("LinkTracking.whoops_msg")),a.default.createElement("div",{className:"ew-actions"},a.default.createElement("button",{className:"u-default-button",onClick:this.fetchData},this.b("actions.try_again")))):l?0==l.length||l.every(function(e){return 0==e.links.length})?a.default.createElement("div",{className:"lt-error-wrapper u-fade-in fscale"},a.default.createElement("h2",null,this.s("LinkTracking.nodata"))):a.default.createElement("div",{className:"content u-paper u-fade-in fscale"},a.default.createElement("div",{className:"table"},a.default.createElement("div",{className:"table-row header"},a.default.createElement("div",{className:"cells expandable"},a.default.createElement("div",{className:"cell wide"},this.s("LinkTracking.table.subject")),a.default.createElement("div",{className:"cell strict"},this.s("LinkTracking.table.sent_at")))),l.map(function(t,n){return e.renderRow(t,n)}))):a.default.createElement(c.default,null))}}]),t}())||d;t.default=w},124:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default=void 0;var a=p(n(0)),i=p(n(1)),l=(p(n(17)),n(4));n(125);var r,d,o,c=p(n(46)),s=p(n(7)),v=p(n(10));function p(e){return e&&e.__esModule?e:{default:e}}function m(e){return function(e){if(Array.isArray(e)){for(var t=0,n=new Array(e.length);t<e.length;t++)n[t]=e[t];return n}}(e)||function(e){if(Symbol.iterator in Object(e)||"[object Arguments]"===Object.prototype.toString.call(e))return Array.from(e)}(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance")}()}function u(e){return(u="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function f(e,t){for(var n=0;n<t.length;n++){var a=t[n];a.enumerable=a.enumerable||!1,a.configurable=!0,"value"in a&&(a.writable=!0),Object.defineProperty(e,a.key,a)}}function b(e,t){return!t||"object"!==u(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function g(e){return(g=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function h(e,t){return(h=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var k=(0,l.observer)((o=d=function(e){function t(e){var n;return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),(n=b(this,g(t).call(this,e))).setToday=function(){var e=v.default.timestamp,t=("undefined"==typeof performance?"undefined":u(performance))!=u(void 0)?0|performance.now():0;n.today=new Date,n.today.setTime(e+t)},n.showPicker=function(){n.setState({picker:!0})},n.hidePicker=function(){n.setState({picker:!1,picked:n.state.selected})},n.clearSelected=function(){n.state.selected&&n.props.onChange(null),n.setState({selected:void 0,picked:void 0,currentMonth:n.today.getMonth(),currentYear:n.today.getFullYear()}),n.modal.handleClose()},n.confirmSelected=function(){if(n.state.picked){var e=n.state,t=e.selected,a=e.picked,i=t&&n.formatDate(t),l=n.formatDate(a);t&&i==l||n.props.onChange(a,l),n.setState({selected:a}),n.modal.handleClose()}},n.formatDate=function(e){return e.toISOString().split("T")[0].split("-").reverse().join(".")},n.renderDates=function(){var e=n.state,t=e.currentMonth,i=e.picked;n.setToday();var l=new Date(n.today.toISOString());return l.setMonth(t),l.getMonth()!=t&&l.setDate(0),l.setDate(1),l.setDate(l.getDate()-(l.getDay()||7)),m(Array(42)).map(function(e,r){l.setDate(l.getDate()+1);var d=new Date(l.toISOString());return a.default.createElement("div",{key:r,className:"date ".concat(i&&n.formatDate(l)==n.formatDate(i)?"picked":n.formatDate(l)==n.formatDate(n.today)?"today":l.getMonth()!=t?"outmonth":[0,6].includes(l.getDay())?"weekend":""),onClick:function(){return n.pickDate(d)}},a.default.createElement("span",{className:"content"},l.getDate()))})},n.pickDate=function(e){var t=n.state.currentMonth,a=e.getMonth();t!=a&&((a>t||0==a)&&n.increaseMonth(1),(a<t||11==a)&&n.increaseMonth(-1)),n.setState({picked:e})},n.prevMonth=function(){n.increaseMonth(-1)},n.nextMonth=function(){n.increaseMonth(1)},n.increaseMonth=function(e){var t=n.state,a=t.currentMonth,i=t.currentYear,l=a+e;n.setState({currentMonth:l<0?11:l>11?0:l,currentYear:l<0?i-1:l>11?i+1:i})},n.handleCancel=function(){n.setState({picked:n.state.selected,currentMonth:(n.state.selected||n.today).getMonth(),currentYear:(n.state.selected||n.today).getFullYear()}),n.modal.handleClose()},n.setToday(),n.state={picker:!1,picked:e.defaultDate,selected:e.defaultDate,currentMonth:n.today.getMonth(),currentYear:n.today.getFullYear()},n}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&h(e,t)}(t,s.default),function(e,t,n){t&&f(e.prototype,t),n&&f(e,n)}(t,[{key:"render",value:function(){var e=this,t=this.state,n=t.selected,i=t.currentMonth,l=t.currentYear;return a.default.createElement("div",{className:"c-datepicker"},a.default.createElement("div",{className:"selected",onClick:this.showPicker},n?this.formatDate(n):a.default.createElement("span",null,this.props.placeholder)),this.state.picker&&a.default.createElement(c.default,{onClose:this.hidePicker,header:this.b("date_picker.header"),className:"dp-modal",ref:function(t){return e.modal=t}},a.default.createElement("div",{className:"month-wrapper"},a.default.createElement("div",{className:"arr",onClick:this.prevMonth},a.default.createElement("img",{src:"/static_office/images/icons/k-arrow-down_black.svg",alt:"prev"})),a.default.createElement("div",{className:"month"},this.b("timing.months").split(",")[i],", ",l),a.default.createElement("div",{className:"arr",onClick:this.nextMonth},a.default.createElement("img",{src:"/static_office/images/icons/k-arrow-down_black.svg",alt:"prev"}))),a.default.createElement("div",{className:"dates-wrapper"},this.renderDates()),a.default.createElement("div",{className:"dp-actions"},a.default.createElement("div",{className:"u-action",onClick:this.handleCancel},this.b("actions.cancel")),a.default.createElement("div",{className:"u-action",onClick:this.clearSelected},this.b("actions.clear")),a.default.createElement("div",{className:"u-action confirm ".concat(this.state.picked?"":"disabled"),onClick:this.confirmSelected},this.b("actions.confirm")))))}}]),t}(),d.propTypes={placeholder:i.default.string,defaultDate:i.default.instanceOf(Date),onChange:i.default.func},d.defaultProps={placeholder:"Select date",onChange:function(){}},r=o))||r;t.default=k},125:function(e,t,n){var a=n(126);"string"==typeof a&&(a=[[e.i,a,""]]);var i={hmr:!0,transform:void 0,insertInto:void 0};n(120)(a,i);a.locals&&(e.exports=a.locals)},126:function(e,t,n){(e.exports=n(119)(!1)).push([e.i,"div.c-datepicker {\n  display: inline-block;\n  margin: 0 10px; }\n  div.c-datepicker div.selected {\n    background: #2ecc71;\n    font-size: 16px;\n    font-weight: 700;\n    line-height: 30px;\n    padding: 0 10px;\n    border-radius: 3px;\n    transition: background 450ms cubic-bezier(0.23, 1, 0.32, 1);\n    cursor: pointer;\n    color: white; }\n    @media (max-width: 729px) {\n      div.c-datepicker div.selected {\n        font-size: 14px;\n        line-height: 25px;\n        margin: 2px 0px; } }\n    div.c-datepicker div.selected:hover {\n      background: rgba(46, 204, 113, 0.72); }\n    div.c-datepicker div.selected span {\n      opacity: .7; }\n  div.c-datepicker div.dp-modal {\n    max-width: 300px !important; }\n    div.c-datepicker div.dp-modal div.dp-actions {\n      margin-top: 20px;\n      text-align: right; }\n    div.c-datepicker div.dp-modal div.month-wrapper {\n      display: flex;\n      align-items: center;\n      justify-content: space-between;\n      font-size: 16px;\n      font-weight: 500;\n      margin-bottom: 20px;\n      text-transform: capitalize; }\n      div.c-datepicker div.dp-modal div.month-wrapper div.arr {\n        width: 40px;\n        height: 40px;\n        border-radius: 3px;\n        background: rgba(0, 0, 0, 0.06);\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        cursor: pointer;\n        transition: background 450ms cubic-bezier(0.23, 1, 0.32, 1); }\n        div.c-datepicker div.dp-modal div.month-wrapper div.arr:hover {\n          background: rgba(0, 0, 0, 0.12); }\n        div.c-datepicker div.dp-modal div.month-wrapper div.arr img {\n          pointer-events: none; }\n        div.c-datepicker div.dp-modal div.month-wrapper div.arr:first-child img {\n          transform: rotate(90deg); }\n        div.c-datepicker div.dp-modal div.month-wrapper div.arr:last-child img {\n          transform: rotate(-90deg); }\n    div.c-datepicker div.dp-modal div.dates-wrapper div.date {\n      display: inline-block;\n      vertical-align: top;\n      width: calc(100% / 7);\n      padding-top: calc(100% / 7);\n      position: relative;\n      cursor: pointer; }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date span {\n        position: absolute;\n        top: 1px;\n        left: 1px;\n        right: 1px;\n        bottom: 1px;\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        font-size: 16px;\n        font-weight: 500;\n        color: rgba(116, 87, 213, 0.54);\n        background: rgba(116, 87, 213, 0.06);\n        border-radius: 3px;\n        transition: all 450ms cubic-bezier(0.23, 1, 0.32, 1); }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date:hover span {\n        background: rgba(116, 87, 213, 0.18);\n        color: #7457d5; }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date.weekend span {\n        background: rgba(244, 67, 54, 0.12);\n        color: rgba(244, 67, 54, 0.54); }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date.weekend:hover span {\n        background: rgba(244, 67, 54, 0.24);\n        color: #f44336; }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date.today span {\n        background: #2ecc71;\n        color: white; }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date.picked span {\n        background: #7457d5;\n        color: white; }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date.outmonth span {\n        color: rgba(0, 0, 0, 0.24);\n        background: rgba(0, 0, 0, 0); }\n      div.c-datepicker div.dp-modal div.dates-wrapper div.date.outmonth:hover span {\n        background: rgba(0, 0, 0, 0.12);\n        color: rgba(0, 0, 0, 0.54); }\n",""])},128:function(e,t,n){var a=n(129);"string"==typeof a&&(a=[[e.i,a,""]]);var i={hmr:!0,transform:void 0,insertInto:void 0};n(120)(a,i);a.locals&&(e.exports=a.locals)},129:function(e,t,n){(e.exports=n(119)(!1)).push([e.i,"main.v-email-link-tracking div.c-main-preloader {\n  margin-top: 40px; }\n\nmain.v-email-link-tracking div.lt-error-wrapper {\n  margin-top: 40px; }\n\nmain.v-email-link-tracking p.extrastate {\n  margin-top: 60px; }\n\nmain.v-email-link-tracking div.content {\n  max-width: 840px;\n  margin: 0 auto;\n  margin-top: 60px; }\n  @media (max-width: 729px) {\n    main.v-email-link-tracking div.content {\n      margin-top: 40px; } }\n  main.v-email-link-tracking div.content div.table {\n    padding: 10px 20px;\n    background: white;\n    border-radius: 6px;\n    margin: 0 auto; }\n    @media (max-width: 729px) {\n      main.v-email-link-tracking div.content div.table {\n        padding: 10px; } }\n    main.v-email-link-tracking div.content div.table div.table-row {\n      border-bottom: 1px solid rgba(116, 87, 213, 0.38); }\n      main.v-email-link-tracking div.content div.table div.table-row div.cells {\n        display: flex;\n        align-items: center;\n        justify-content: space-between;\n        padding: 10px 0 10px 10px;\n        position: relative; }\n        main.v-email-link-tracking div.content div.table div.table-row div.cells.expandable {\n          padding-right: 40px !important; }\n          @media (max-width: 729px) {\n            main.v-email-link-tracking div.content div.table div.table-row div.cells.expandable {\n              display: block; }\n              main.v-email-link-tracking div.content div.table div.table-row div.cells.expandable div.cell.strict {\n                width: 100%;\n                text-align: left;\n                margin-top: 20px; } }\n        main.v-email-link-tracking div.content div.table div.table-row div.cells div.expand {\n          position: absolute;\n          top: 0;\n          left: auto;\n          right: 0;\n          bottom: 0;\n          width: 40px;\n          cursor: pointer;\n          transition: background 450ms cubic-bezier(0.23, 1, 0.32, 1); }\n          main.v-email-link-tracking div.content div.table div.table-row div.cells div.expand:hover {\n            background: rgba(116, 87, 213, 0.06); }\n          main.v-email-link-tracking div.content div.table div.table-row div.cells div.expand img {\n            position: absolute;\n            top: calc(50% - 10px);\n            left: calc(50% - 10px);\n            right: auto;\n            bottom: auto;\n            width: 20px;\n            height: 20px;\n            transition: transform 450ms cubic-bezier(0.23, 1, 0.32, 1);\n            pointer-events: none; }\n            @media (max-width: 729px) {\n              main.v-email-link-tracking div.content div.table div.table-row div.cells div.expand img {\n                position: sticky;\n                top: 90px;\n                left: 10px;\n                right: 10px;\n                bottom: auto;\n                margin: 10px; } }\n        main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell {\n          flex-grow: 1;\n          flex-shrink: 1; }\n          main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide {\n            font-size: 16px;\n            font-weight: 700;\n            margin-right: 20px; }\n            main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.cw-content {\n              display: flex;\n              align-items: center;\n              justify-content: space-between; }\n              @media (max-width: 729px) {\n                main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.cw-content {\n                  display: block; } }\n              main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.cw-content span:last-child {\n                display: block;\n                font-weight: 500;\n                opacity: .72;\n                font-size: 14px; }\n                @media (max-width: 729px) {\n                  main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.cw-content span:last-child {\n                    margin-top: 10px; } }\n                main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.cw-content span:last-child span.translation-placeholder {\n                  max-width: 80px;\n                  float: left;\n                  margin-right: 5px; }\n                  main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.cw-content span:last-child span.translation-placeholder:before {\n                    left: 0; }\n            main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.recipients {\n              border-top: 1px solid rgba(116, 87, 213, 0.12);\n              margin-top: 10px;\n              font-size: 14px;\n              font-weight: 400; }\n              main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.recipients:before {\n                content: attr(data-label);\n                font-size: 15px;\n                font-weight: 500;\n                color: rgba(0, 0, 0, 0.54);\n                display: block;\n                line-height: 15px;\n                margin: 10px 0; }\n              main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.wide div.recipients > div {\n                margin-bottom: 1px;\n                font-size: 15px;\n                font-weight: 500; }\n          main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.strict {\n            width: 140px;\n            flex-grow: 0;\n            flex-shrink: 0;\n            text-align: center; }\n            @media (max-width: 729px) {\n              main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.strict br {\n                display: none; } }\n            @media (max-width: 729px) {\n              main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.strict span.offset {\n                margin: 0 3px; } }\n            main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell.strict.smaller {\n              width: 100px; }\n          main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell:not(.wide):not(.strict) {\n            overflow: hidden;\n            text-overflow: ellipsis;\n            white-space: nowrap;\n            max-width: calc(100% - 100px); }\n          main.v-email-link-tracking div.content div.table div.table-row div.cells div.cell a {\n            color: blue;\n            text-decoration: underline; }\n      main.v-email-link-tracking div.content div.table div.table-row:not(.header) > div.cells {\n        transition: background 450ms cubic-bezier(0.23, 1, 0.32, 1); }\n        main.v-email-link-tracking div.content div.table div.table-row:not(.header) > div.cells:hover {\n          background: rgba(116, 87, 213, 0.03); }\n      main.v-email-link-tracking div.content div.table div.table-row.header {\n        border-bottom: none; }\n        main.v-email-link-tracking div.content div.table div.table-row.header div.cells {\n          padding: 0 0 0 10px; }\n          @media (max-width: 729px) {\n            main.v-email-link-tracking div.content div.table div.table-row.header div.cells.expandable {\n              display: none; } }\n          main.v-email-link-tracking div.content div.table div.table-row.header div.cells div.cell {\n            opacity: .72;\n            line-height: 30px;\n            font-size: 18px;\n            font-weight: 500;\n            color: #7457d5; }\n            main.v-email-link-tracking div.content div.table div.table-row.header div.cells div.cell span.translation-placeholder:before {\n              top: 12px;\n              bottom: 12px;\n              max-width: 120px; }\n      main.v-email-link-tracking div.content div.table div.table-row.expanded div.additional-content {\n        display: block; }\n      main.v-email-link-tracking div.content div.table div.table-row.expanded div.cells div.expand img {\n        transform: rotateX(-180deg) translateZ(0); }\n      main.v-email-link-tracking div.content div.table div.table-row:last-child {\n        border-bottom: 0; }\n      main.v-email-link-tracking div.content div.table div.table-row div.additional-content {\n        padding: 0 15px 10px 15px;\n        background: rgba(116, 87, 213, 0.06);\n        margin-bottom: 10px;\n        display: none;\n        color: rgba(0, 0, 0, 0.54); }\n        @media (max-width: 729px) {\n          main.v-email-link-tracking div.content div.table div.table-row div.additional-content {\n            padding: 0 5px 10px 5px; } }\n        main.v-email-link-tracking div.content div.table div.table-row div.additional-content div.table-row {\n          border-color: rgba(116, 87, 213, 0.12); }\n          main.v-email-link-tracking div.content div.table div.table-row div.additional-content div.table-row.header {\n            color: black; }\n        main.v-email-link-tracking div.content div.table div.table-row div.additional-content p.subheader {\n          padding-top: 10px; }\n",""])}});