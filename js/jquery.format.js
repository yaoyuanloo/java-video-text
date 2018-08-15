/*
* Jquery Format Plugin
* Copyright (c) 2012-2013 CERC HuangAnzhi 2013-02-20
* huanganzhi@cerc.net.cn
* Version 1.0.0 build 20140304
* Requires jquery v1.8.0+
*/
(function ($) {

    var currentPath = {};

    var dynamicLoadExtJs = false;

    var browser = {
        ie: false,
        ie6: false,
        ie8: false,
        firefox: false,
        safari: false,
        opera: false,
        version: -1
    };

    var formatInputVariable = {
        skinName: "default",
        wrapClass: "indieui-form",
        scriptName: "jquery.format.js",
        cssName: "jquery.format.css",
        pluginName: "Jquery IndieForma"
    };

    var externalPlugin = {
        poshyTip: { js: "jquery.poshytip-1.1/src/jquery.poshytip.min.js", css: "", isLoaded: false },
        processmask: { js: "jquery.processmask.js", css: "processmask/jquery.processmask.css", isLoaded: false },
        my97DatePicker: { js: "My97DatePicker/WdatePicker.js", css: "", isLoaded: false }
    };

    /*
    �Զ�����Ժ������������֧��FireBugʱ�����ڿ���̨���������Ϣ������ʹ��alert()��������������Ϣ
    */
    var debug = function (info) {
        if ($.formatInput.defaults.debug) {
            if (typeof console != "undefined" && typeof console.debug != "undefined") {
                console.log('format plugin debug info:' + info);
            } else {
                alert(info);
            }
        }
    };

    /*
    ʶ��������汾
    */
    var useragent = navigator.userAgent.toLowerCase();
    if (useragent.indexOf("opera") != -1) {
        browser.opera = true;
    } else if (useragent.indexOf("msie") != -1) {
        browser.ie = true;
        browser.version = parseFloat(useragent.substring(useragent.indexOf('msie') + 4));
        if (browser.version == 6) {
            browser.ie6 = true;
            browser.ie8 = false;
        }
        else if (browser.version == 8) {
            browser.ie6 = false;
            browser.ie8 = true;
        }
    } else if (useragent.indexOf("safari") != -1) {
        browser.safari = true;
        browser.version = parseFloat(useragent.substring(useragent.indexOf('safari') + 7));
    } else if (useragent.indexOf("gecko") != -1) {
        browser.firefox = true;
    }

    /*
    ��ȡִ�нű�����Ŀ¼(src)·������ʹ��currentPath�������б���
    */
    var scriptElements = document.scripts;
    for (var i = scriptElements.length; i > 0; i--) {
        var obj = scriptElements[i - 1];
        if (obj.src.indexOf(formatInputVariable.scriptName) > -1) {
            var url = obj.src.replace('\\', '\/');
            currentPath = url.substring(0, url.lastIndexOf("src/" + formatInputVariable.scriptName));
            break;
        }
    }

    //����չ
    $.formatInput = {
        //Ĭ������
        defaults: {
            skin: formatInputVariable.skinName,
            debug: false,
            external: {
                my97DatePicker: true,
                poshyTip: true,
                processmask: true
            }
        },

        /*
        �ຯ��
        */
        formatInput: function (options) {
            var currentSkin = $.formatInput.defaults.skin;

            $.formatInput.defaults = $.extend({}, $.formatInput.defaults, options);

            if (currentSkin != $.formatInput.defaults.skin) {
                $.formatInput.loadSkin(formatInputVariable.skinName);
            }
            $("." + formatInputVariable.wrapClass).formatInput();
        },

        /*
        ����Ƥ������
        */
        loadSkin: function (skinName) {
            if (currentPath == '') {
                debug(formatInputVariable.pluginName + ' ��������쳣');
                return false;
            }
            var cssUrl = currentPath + "themes/" + skinName + "/format/" + formatInputVariable.cssName;
            $.formatInput.loadStylesheet(cssUrl);
        },

        /*
        ���ؽű�
        */
        loadScript: function (scriptUrl, callback) {
            var scriptExits = false;
            var scripts = document.getElementsByTagName("script");
            for (var i = 0; i < scripts.length; i++) {
                if ($(scripts[i]).attr("src") == scriptUrl) {
                    scriptExits = true;
                    break;
                }
            }
            if (!scriptExits) {
                var scriptDom = document.createElement("script");
                scriptDom.type = "text/javascript";
                scriptDom.src = scriptUrl;
                scriptDom.onload = scriptDom.onreadystatechange = function () {
                    if (!scriptDom.readyState || scriptDom.readyState == "loaded" || scriptDom.readyState == "complete") {
                        scriptExits = true;
                        scriptDom.onload = scriptDom.onreadystatechange = null;
                        callback && callback.call(scriptDom);
                    }
                };
                document.getElementsByTagName("head")[0].appendChild(scriptDom);
            }
        },

        /*
        ������ʽ�ļ�
        */
        loadStylesheet: function (cssUrl, callback) {

            var linkExits = false;
            var links = document.getElementsByTagName("link");
            for (var i = 0; i < links.length; i++) {
                if ($(links[i]).attr("src") == cssUrl) {
                    linkExits = true;
                    break;
                }
            }
            if (!linkExits) {
                var linkDom = document.createElement("link");
                linkDom.rel = "stylesheet";
                linkDom.type = "text/css";
                linkDom.media = "screen";
                linkDom.href = cssUrl;
                document.getElementsByTagName("head")[0].appendChild(linkDom);
                callback && callback.call(linkDom);
            }
        }
    };

    //����Ĭ����ʽ�ļ�
    $.formatInput.loadSkin(formatInputVariable.skinName);

    //Ĭ�ϸ�ʽ����ʽ
    $(document).ready(function () {
        $.formatInput.formatInput();
        $(".indieui-scroll").fixedScroll();
        $("table[fixedheader]").fixedheader();
    });

    /*
    ����չ����ű��Ķ�̬�����߼�����formatInput�����У����߼��Ͽ����ִ��Ч�ʺ������Դ�������ܣ�����
    �����ԣ����ֽ���̬�����߼�����formatInput�����к󣬶Խű���Դ�Ƿ���ɵ��߼��жϱȽϸ��ӣ����Ҿ���
    �����޷�Ԥ֪�Ĵ�����˽����߼�������formatInput�ຯ���ⲿ����ʱ�ɽ����������߿���ҳ�����ֶ���
    ����չ����ű��Խ��������
    */
    if ($.formatInput.defaults.external.my97DatePicker) {
        $.formatInput.loadScript(currentPath + "external/" + externalPlugin.my97DatePicker.js);
    }
    if ($.formatInput.defaults.external.poshyTip) {
        $.formatInput.loadScript(currentPath + "external/" + externalPlugin.poshyTip.js);
    }
    if ($.formatInput.defaults.external.processmask) {
        $.formatInput.loadScript(currentPath + "src/" + externalPlugin.processmask.js);
    }

    $.fn.formatInput = function () {

        this.each(function () {
            var $this = $(this);
            //��ʼ���ı�����ʽ
            var $inputTxt = $this.find(":text").not("[disableStyle]");
            debug("����������ѯ��Χ���ı���:text��" + $inputTxt.length + "��");
            debug("��ʼִ����ʽ��ʽ��");

            $inputTxt.each(function () {
                setInputTxtStyle(this);
                if ($(this).attr("disabled")) {
                    $(this).disable();
                }
                else {
                    var dateFormat = $(this).attr("dateFormat");
                    if ($(this).attr("readonly") && dateFormat == undefined) {
                        $(this).readonly();
                    }
                    if (!dynamicLoadExtJs && true) {
                        addInputTipEvent(this);

                        if (dateFormat != undefined) {

                            debug("����������ѡ��ؼ������ڸ�ʽ����:" + dateFormat + "����ʼ���г�ʼ����");

                            $(this).addClass("FormatInputInputDate");
                            $(this).bind("focus", function () {
                                try {
                                    if (dateFormat == "") {
                                        dateFormat = "yyyy-MM-dd";
                                        $(this).attr("dateFormat", "yyyy-MM-dd");
                                    }
                                    WdatePicker({ dateFmt: dateFormat, autoPickDate: true });
                                }
                                catch (e) { alert('���ڿؼ�����ʧ�ܣ�' + '\r\n' + e); }
                            });

                            debug("���ڿؼ���ʼ����ɣ�");
                        }
                    }
                }
            });
            debug("���ı���:text����ʽ��ʽ�����");

            //��ʼ���������ʽ
            var $inputPwd = $this.find(":password").not("[disableStyle]");

            debug("����������ѯ��Χ�������:password��" + $inputPwd.length + "��");
            debug("��ʼִ����ʽ��ʽ��");

            $inputPwd.each(function () {
                setInputTxtStyle(this);
                if ($(this).attr("disabled")) {
                    $(this).disable();
                }
                else {
                    if ($(this).attr("readonly")) {
                        $(this).readonly();
                    }
                    if (!dynamicLoadExtJs && true) {
                        addInputTipEvent(this);
                    }
                }
            });
            debug("�����:password����ʽ��ʽ�����");

            //��ʼ���ļ�ѡ������ʽ
            var $inputFile = $this.find(":file").not("[disableStyle]");

            debug("����������ѯ��Χ���ļ���:file��" + $inputFile.length + "��");
            debug("��ʼִ����ʽ��ʽ��");

            $inputFile.each(function () {
                setInputTxtStyle(this);
                if ($(this).attr("disabled") || $(this).attr("readonly")) {
                    $(this).disable();
                }
            });
            debug("�ļ���:file����ʽ��ʽ�����");

            var $inputTextarea = $this.find("textarea").not("[disableStyle]");

            debug("����������ѯ��Χ�ڶ����ı���textarea��" + $inputTextarea.length + "��");
            debug("��ʼִ����ʽ��ʽ��");

            $inputTextarea.each(function () {
                $(this).addClass("FormatInputInputMultiTxt");
                if ($(this).attr("disabled")) {
                    $(this).disable();
                }
                else {
                    if ($(this).attr("readonly")) {
                        $(this).readonly();
                    }
                    $(this).focus(function () {
                        $(this).addClass("FormatInputInputTxtFocus");
                    });
                    $(this).blur(function () {
                        $(this).removeClass("FormatInputInputTxtFocus");
                    });
                    if (!dynamicLoadExtJs && true) {
                        addInputTipEvent(this);
                    }
                }
            });
            debug("�����ı���textarea����ʽ��ʽ�����");

            var $inputButton = $this.find("input[type='button'], input[type='submit'], input[type='reset'], button").not("[disableStyle]");
            $inputButton.each(function () {
                $(this).addClass("FormatInputBtn");
            });

            //IE6��֧��CSSα�࣬ͨ���ű�ʵ����ʾ����Ч��
            if (browser.ie6) {
                debug("IE6�������ã���ť��껮��Ч��");
                $inputButton.each(function () {
                    $(this).hover(
                                function () {
                                    $(this).addClass("FormatInputBtnHover");
                                },
                                function () {
                                    $(this).removeClass("FormatInputBtnHover");
                                }
                            );
                });
            }
        });
    };

    $.fn.fixedScroll = function (options) {
        $.fn.fixedScroll.defaults = $.extend({}, $.fn.fixedScroll.defaults, options);
        var $this = $(this);
        var fixedCount = $this.length;
        var otr = $this.siblings(":visible").not($this).not(".SearchBoxMask, .SearchBox, [class^='tip']");
        var otrCount = 0;

        var otrH = 0;

        debug("��������Ԫ�ظ�����" + fixedCount);
        
        //���������CSS margin-top �����ص� BUG
        var marginFixed = "<p class=\"MarginHolder\">&nbsp;</p>";
        $this.find(" .InfoBox").before(marginFixed);
        
        otr.each(function (i, n) {
        	 if (otr.position().top == -1970) {
                 otrH += 0;
             }
             else {          	
                 debug("Ԫ��" + i + "�߶�:" + $(this).outerHeight(true));
                 
                 otrH += $(this).outerHeight(true);
                 otrCount++;
             }
        });
        
        debug("����������Ԫ�ظ�����" + otrCount);
        debug("����������Ԫ�ظ߶��ܺ�����" + otrH);

        var resize = function (list) {
            var winH = $("body").outerHeight(); 
            debug("����߶�" + winH);
            if(otrH>=winH){
            	 debug("����ֵ���ڴ���߶ȣ���0");
            	otrH = 0;            
            }
            var fixedH = (winH - otrH) / fixedCount;
            debug("�����߶�" + fixedH);
            list.each(function (i, n) {
                $(this).css({ "height": fixedH + "px", "overflow": "auto", "clear": "both" });
                $("body").css({ "overflow": "hidden" });
            });
        };
        resize($this);
        $(window).resize(function () {
            resize($this);
        });
    };

    $.fn.fixedScroll.defaults = {

    };

    $.fn.searchBox = function (options) {
        if (typeof options == "string") {
            return $.fn.searchBox.methods[options](this);
        }

        $("body").prepend("<div class=\"SearchBoxMask\"></div>")
        $(".SearchBoxMask").show();
        var opts = $.extend({}, $.fn.searchBox.defaults, options);
        return this.each(function (i, n) {
            var $this = $(this);
            $this.attr("idx", i);
            $this.width(opts.width);
            $this.css("margin-left", 0 - opts.width / 2 + "px");
            var titleDom = "<h3 idx='" + i + "'><span class=\"TitleTxt\">" + opts.title + "</span><a idx=\"" + i + "\" class=\"CloseBtn\">��</a></h3>";

            $this.prepend(titleDom);
            $this.show();

            $this.find(".CloseBtn").click(function () {
                var idx = $(this).attr("idx");
                $(".SearchBoxMask").remove();
                $this.find("h3[idx='" + idx + "']").remove();
                $(".SearchBox[idx='" + idx + "']").hide();
            });
        });
    };

    $.fn.searchBox.methods = {
        close: function (box) {
            box.each(function () {
                var $this = $(this);
                var idx = $this.attr("idx");
                $this.find(".CloseBtn[idx='" + idx + "']").click();
            });
        }
    };

    $.fn.searchBox.defaults = {
        title: "��ѯ",
        width: 750
    };

    $.fn.disable = function () {
        return this.each(function () {
            var $this = $(this);
            $this.attr('disabled', true);
            $this.addClass("FormatInputCtrlDisable");
        });
    };

    $.fn.enable = function () {
        return this.each(function () {
            var $this = $(this);
            $this.removeAttr('disabled');
            $this.removeClass("FormatInputCtrlDisable");
        });
    };

    $.fn.readonly = function () {
        return this.each(function () {
            var $this = $(this);
            $this.attr('readonly', true);
            $this.addClass("FormatInputCtrlDisable");
        });
    };

    $.fn.nonreadonly = function () {
        return this.each(function () {
            var $this = $(this);
            $this.removeAttr('readonly');
            $this.removeClass("FormatInputCtrlDisable");
        });
    };

    $.fn.fixedheader = function (options, extValue) {
        if (!this.is("table")) {
            return false;
        }
        var opts = $.extend({}, $.fn.fixedheader.defaults, options);

        var getCloneTable = function (table) {
            var _table = $(table).clone();
            _table.find("tbody, tfoot").remove();

            _table.css("position", "relative");
            _table.css("left", "0px");
            _table.css("z-index", "2");
            _table.removeAttr("id");
            _table.hide();

            var _war = $(table).parent();
            _war.scroll(function () {
                var top = _war.scrollTop();
                if (top > 0) {
                    _table.show();
                    _table.css("top", top);
                }
                else {
                    _table.hide();
                }
            });

            return _table;
        };

        this.each(function () {
            var $this = $(this);
            var cloneTable = getCloneTable(this);
            $this.before(cloneTable);
        });
    };

    $.fn.fixedheader.defaults = {
        zebra: true,
        fixheader: false,
        width: "100%",
        height: "600",
        debug: false
    };

    var addInputTipEvent = function (o) {
        var $this = $(o);
        if (!$this.attr("disabled") && !$this.attr("readonly")) {
            if ($this.poshytip && $this.attr("title") != undefined && $this.attr('title') != "") {
                $this.poshytip({
                    className: 'tip-yellow',
                    showOn: 'focus',
                    alignTo: 'target',
                    alignX: 'inner-left',
                    offsetX: 0,
                    offsetY: 5
                });
            }
        }
    };

    var setInputTxtStyle = function (o) {
        $(o).addClass("FormatInputInputTxt");
        $(o).focus(function () {
            $(o).addClass("FormatInputInputTxtFocus");
        });
        $(o).blur(function () {
            $(o).removeClass("FormatInputInputTxtFocus");
        });
    };

})(jQuery);

var uiInitialization = function () {
    try {
        $.formatInput.formatInput();
        //$(".indieui-scroll").fixedScroll();
    }
    catch (e) {
        
    }
};