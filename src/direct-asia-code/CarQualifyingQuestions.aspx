//START PK.Framework.Web.Resources.JavaScripts.FrameWork.js
var isIE = (navigator.appName.indexOf("Microsoft")!=-1)? true:false;
function GetLabelInnerText(id)
{
    var regExp = /<\/?[^>]+>/gi;
    var obj = $get(id);
    if( obj != null )
    {
        return obj.innerHTML.replace(regExp,'');
    }
    return '';
};
function __RegPKRealNumber(extcid)
{
    var obj = $find(extcid);
    if( obj ) obj.add_processKey(__PKRealNumber);
    else setTimeout(function(){__RegPKRealNumber(extcid);}, 100);
};
function __PKRealNumber(sender, e)
{
    if (e.get_key() == '.')
    {
        if( e.get_text() == '' )
        {
            e.set_allowKey(true);
            return;
        }
        var count = __GetDotCount(e.get_text());
        if( e.get_mode() == 1 && count > 0 )
        {
            e.set_allowKey(false);
            return;
        }
        if( e.get_mode() == 2 && count > 1 )
        {
            e.set_allowKey(false);
            return;
        }
    }
};
function __GetDotCount(text)
{
    var count = 0;
    for (var i = 0; i < text.length; i++) 
    {
        var ch = text.substring(i, i+1);
        if (ch == ".") count++;
    }
    return count;
};
function CheckboxRequired_VD(source, args)
{
    var chk = $get(source.controltovalidate);
    args.IsValid = chk.checked;
};
function OAA_DoPostBackWithOptions(uid, id, disablectl, options)
{
    if( options != null )
    {
        WebForm_DoPostBackWithOptions(options);
        if (typeof(Page_IsValid) == 'boolean') 
            if (Page_IsValid == false) 
                 return false;
        __doPostBack(options.eventTarget, options.eventArgument);         
    }   
    else
    {
        __doPostBack(uid, '');  
    }
    if( disablectl )
    {
        $get(id).disabled = true;
    }
};
function CheckboxListRequired_VD(sender, args)
{
    if (document.getElementById(sender.controltovalidate))
    {
        var checkboxList = document.getElementById(sender.controltovalidate);
        if (checkboxList.getElementsByTagName)
        { 
            args.IsValid = false;
            var inputs = checkboxList.getElementsByTagName("input");
            for (j=0;j<inputs.length; j++)
            {
                if( inputs[j].checked ) {args.IsValid = true;}
            }
        }
    }
};

var preloadCssImages = {
    imgUrls: [],
    divPreImages: null,
    
    Load: function() {
        this.parseCSS(document.styleSheets);
    },
    
    InitPreImageDiv: function() {
        this.divPreImages = document.createElement("div");
        this.divPreImages.style.display = "none";
        this.divPreImages.style.visibility = "hidden";
        document.body.appendChild(this.divPreImages);
    },
    
    inArray: function( elem, array ) {
		for ( var i = 0, length = array.length; i < length; i++ )
			if ( array[ i ] === elem )
				return i;
		return -1;
	},
	
    parseCSS: function(sheets) {
        var w3cImport = false,
			imported = [],
			importedSrc = [],
			baseURL;
		var sheetIndex = sheets.length;
		while(sheetIndex--){//loop through each stylesheet
			var cssPile = '';//create large string of all css rules in sheet
			var csshref = (sheets[sheetIndex].href) ? sheets[sheetIndex].href : 'window.location.href';
			var baseURLarr = csshref.split('/');//split href at / to make array
			baseURLarr.pop();//remove file path from baseURL array
			baseURL = baseURLarr.join('/');//create base url for the images in this sheet (css file's dir)
			if (baseURL) {
				baseURL += '/'; //tack on a / if needed
	        }
	        if(sheets[sheetIndex].cssRules || sheets[sheetIndex].rules){
				thisSheetRules = (sheets[sheetIndex].cssRules) ? //->>> http://www.quirksmode.org/dom/w3c_css.html
					sheets[sheetIndex].cssRules : //w3
					sheets[sheetIndex].rules; //ie 
				var ruleIndex = thisSheetRules.length;
				while(ruleIndex--){
					if(thisSheetRules[ruleIndex].style && thisSheetRules[ruleIndex].style.cssText){
						var text = thisSheetRules[ruleIndex].style.cssText;
						if(thisSheetRules[ruleIndex].selectorText.indexOf('hover') != -1) { //only add hover class....
						    if(text.toLowerCase().indexOf('url') != -1){ // only add rules to the string if you can assume, to find an image, speed improvement
							    cssPile += text; // thisSheetRules[ruleIndex].style.cssText instead of thisSheetRules[ruleIndex].cssText is a huge speed improvement
						    }
						}
					} else if(thisSheetRules[ruleIndex].styleSheet) {
						imported.push(thisSheetRules[ruleIndex].styleSheet);
						w3cImport = true;
					}
					
				}
			}
			//parse cssPile for image urls
			var tmpImage = cssPile.match(/[^\("]+\.(gif|jpg|jpeg|png)/g);
			//reg ex to get a string of between a "(" and a ".filename" / '"' for opera-bugfix
			if(tmpImage){
				var i = tmpImage.length;
				while(i--){ // handle baseUrl here for multiple stylesheets in different folders bug
					var imgSrc = (tmpImage[i].charAt(0) == '/' || tmpImage[i].match('://')) ? // protocol-bug fixed
						tmpImage[i] : 
						baseURL + tmpImage[i];
					
					if(this.inArray(imgSrc, this.imgUrls) == -1){
						this.imgUrls.push(imgSrc);
					}
				}
			}
			if(!w3cImport && sheets[sheetIndex].imports && sheets[sheetIndex].imports.length) {
				for(var iImport = 0, importLen = sheets[sheetIndex].imports.length; iImport < importLen; iImport++){
					var iHref = sheets[sheetIndex].imports[iImport].href;
					iHref = iHref.split('/');
					iHref.pop();
					iHref = iHref.join('/');
					if (iHref) {
						iHref += '/'; //tack on a / if needed
					}
					var iSrc = (iHref.charAt(0) == '/' || iHref.match('://')) ? // protocol-bug fixed
						iHref : 
						baseURL + iHref;
					
					importedSrc.push(iSrc);
					imported.push(sheets[sheetIndex].imports[iImport]);
				}
			}
		}//loop
		if(imported.length){
			parseCSS(imported, importedSrc);
			return false;
		}
		if( this.imgUrls && this.imgUrls.length > 0 ) {
		    this.InitPreImageDiv();
		    this.loadImgs();
		}
    },
    
    loadImgs: function(){
        if(this.imgUrls && this.imgUrls.length){
            for ( var i = 0, length = this.imgUrls.length; i < length; i++ )
            {
			    var img = new Image(); //new img obj
			    img.src = this.imgUrls[i];	//set src either absolute or rel to css dir
			    this.divPreImages.appendChild(img);
			}
		}    
    }
};
function __SmartDateTextBoxOnKeyUpOrDown(evt)
{
    if( !evt && window.event )
    {
        evt = window.event;
    }
    var keyCode;
    if (evt.keyCode) keyCode = evt.keyCode;
    else if (evt.which) keyCode = evt.which;
    if( keyCode != 8 && keyCode != 46)
    {
        var _ctl;
        if( evt.target ) _ctl = evt.target;
        else if (evt.srcElement) _ctl = evt.srcElement;
	    if (_ctl.nodeType == 3) // defeat Safari bug
		    _ctl = _ctl.parentNode;
        var _value = _ctl.value;
        switch(_ctl.getAttribute("fmt"))
        {
            case 'dmy':
            case 'mdy':
                if( /^\d{2}$/.test(_value) || /^\d{2}[.\-\/]\d{2}$/.test(_value))    
                {
                    _ctl.value += _ctl.getAttribute("dp");
                }
                break;
            case 'ymd':
                if( /^\d{4}$/.test(_value) || /^\d{4}[.\-\/]\d{2}$/.test(_value) )
                {
                    _ctl.value += _ctl.getAttribute("dp");
                }
                break;
        }
    }
};
function SetUniqueRadioButton(nameregex, current)
{
   re = new RegExp(nameregex);
   var arr = document.getElementsByTagName("input");
   for(i = 0; i < arr.length; i++)
   {
      elm = arr[i];
      if (elm.type == 'radio')
      {
         if (re.test(elm.name))
         {
            elm.checked = false;
         }
      }
   }
   current.checked = true;
};
function LoadIframe(frameName, urlToLoad, showLoading)
{
    if( showLoading )
        __ShowLBLoading();
    if( isIE )
    {
        document.frames[frameName].location.href = urlToLoad;
    }
    else
    {
        $get(frameName).src = urlToLoad;
    }
};
function GetDocument(frameName)
{
    if( isIE )
    {
        return document.frames[frameName].document;
    }
    else
    {
        return $get(frameName).contentDocument;
    }
};
function GetWindow(frameName)
{
    if( isIE )
    {
        return document.frames[frameName];
    }
    else
    {
        return $get(frameName).contentWindow;
    }
};
var tm_AutoHeightFrame = null;

function AutoHeightFrame(frameName)
{
    AutoHeightFrame1(frameName);
    if( tm_AutoHeightFrame == null )
    {
        tm_AutoHeightFrame = setInterval(function(){AutoHeightFrame1(frameName);}, 200);
    }    
//    if( typeof(WebForm_RestoreScrollPosition) == 'function')
//        WebForm_RestoreScrollPosition();        
};
function AutoHeightFrame1(frameName)
{
    var frm = document.getElementById(frameName);     
    if( frm == null ) return;
    var frameBody = GetDocument(frameName).body;
    if( frameBody == null ) return;
    var _height = frameBody.scrollHeight;
    if( _height < 410 ) {_height=410;}
    frm.height = _height; 
};
function IframeOnload(frameName)
{
    __HideLBLoading();
    AutoHeightFrame(frameName);
};
function __toUpper(ctl)
{
    var start = ctl.selectionStart;
    var end = ctl.selectionEnd;
    ctl.value=ctl.value.toUpperCase();
    ctl.selectionStart = start;
    ctl.selectionEnd = end;
};
function __toLower(ctl)
{
    var start = ctl.selectionStart;
    var end = ctl.selectionEnd;
    ctl.value=ctl.value.toLowerCase();
    ctl.selectionStart = start;
    ctl.selectionEnd = end;
};
function __StringCompareValidatorIgnoreCase(source, args)
{
    var s1 = ValidatorTrim(document.getElementById(source.controltovalidate).value).toLowerCase();
    var s2 = ValidatorTrim(document.getElementById(source.getAttribute("ControlToCompare")).value).toLowerCase();
    if( s1 == s2 ) args.IsValid = true;
    else args.IsValid = false;
};
function __StringCompareValidator(source, args)
{
    var s1 = ValidatorTrim(document.getElementById(source.controltovalidate).value);
    var s2 = ValidatorTrim(document.getElementById(source.getAttribute("ControlToCompare")).value);
    if( s1 == s2 ) args.IsValid = true;
    else args.IsValid = false;
};
function __calExtenderOnShown(sender, args)
{
    if( sender._textbox.get_Value() == '' )
    {
        var txt = $(sender.get_element());
        var dt = new Date();
        dt.setFullYear(txt.attr("DYear") , txt.attr("DMonth"), txt.attr("DDay"));
        sender._switchMode(txt.attr("DMode"), true);
        sender.set_visibleDate(dt);
    }
};
function __enableAjaxProgressBar()
{
    __showAjaxLoading = true;
    setTimeout(function(){__showAjaxLoading=false;}, 200);
}

function __InitUdateProgressPanel()
{
    var __manager = Sys.WebForms.PageRequestManager.getInstance();
    if( __manager)
    {
        __manager.add_endRequest(__OnEndRequest);
        __manager.add_beginRequest(__OnBeginRequest);
    }
} 
function __OnBeginRequest(sender, args)
{
    var postBackElement = $(args.get_postBackElement());
    var pgs = postBackElement.attr("UpdateProgressID");
    var controlsToDisable = postBackElement.attr("ControlsToDisable");
    
    if( pgs && pgs != '')
    {
        var progressBars = pgs.split(',');
        $(progressBars).each(function(){
            $("#"+this).css("display", "");
        });
    }
    
    if( controlsToDisable && controlsToDisable != '')
    {
        var cs = controlsToDisable.split(',');
        $(cs).each(function(){
            var ctl = $("#"+this);
            ctl.attr("disabled", true);
            ctl.addClass("readonly")
        });
    }
} 
function __OnEndRequest(sender, args)
{
};
function __fixNetValidationBug(obj)
{
    $(obj).focus();
    if (typeof (Page_ClientValidate) == 'function') {
        validationResult = Page_ClientValidate('_FixPreviousValidationError_Bug');
        if( AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout)
        {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide(); 
        }
    }
}
//END PK.Framework.Web.Resources.JavaScripts.FrameWork.js
//START AjaxControlToolkit.Common.Common.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.BoxSide = function() {
}
AjaxControlToolkit.BoxSide.prototype = {
Top : 0,
Right : 1,
Bottom : 2,
Left : 3
}
AjaxControlToolkit.BoxSide.registerEnum("AjaxControlToolkit.BoxSide", false);AjaxControlToolkit._CommonToolkitScripts = function() {
}
AjaxControlToolkit._CommonToolkitScripts.prototype = {
_borderStyleNames : ["borderTopStyle","borderRightStyle","borderBottomStyle","borderLeftStyle"],
_borderWidthNames : ["borderTopWidth", "borderRightWidth", "borderBottomWidth", "borderLeftWidth"],
_paddingWidthNames : ["paddingTop", "paddingRight", "paddingBottom", "paddingLeft"],
_marginWidthNames : ["marginTop", "marginRight", "marginBottom", "marginLeft"],
getCurrentStyle : function(element, attribute, defaultValue) {
var currentValue = null;if (element) {
if (element.currentStyle) {
currentValue = element.currentStyle[attribute];} else if (document.defaultView && document.defaultView.getComputedStyle) {
var style = document.defaultView.getComputedStyle(element, null);if (style) {
currentValue = style[attribute];}
}
if (!currentValue && element.style.getPropertyValue) {
currentValue = element.style.getPropertyValue(attribute);}
else if (!currentValue && element.style.getAttribute) {
currentValue = element.style.getAttribute(attribute);} 
}
if ((!currentValue || currentValue == "" || typeof(currentValue) === 'undefined')) {
if (typeof(defaultValue) != 'undefined') {
currentValue = defaultValue;}
else {
currentValue = null;}
} 
return currentValue;},
getInheritedBackgroundColor : function(element) {
if (!element) return '#FFFFFF';var background = this.getCurrentStyle(element, 'backgroundColor');try {
while (!background || background == '' || background == 'transparent' || background == 'rgba(0, 0, 0, 0)') {
element = element.parentNode;if (!element) {
background = '#FFFFFF';} else {
background = this.getCurrentStyle(element, 'backgroundColor');}
}
} catch(ex) {
background = '#FFFFFF';}
return background;},
getLocation : function(element) {
if (element === document.documentElement) {
return new Sys.UI.Point(0,0);}
if (Sys.Browser.agent == Sys.Browser.InternetExplorer && Sys.Browser.version < 7) {
if (element.window === element || element.nodeType === 9 || !element.getClientRects || !element.getBoundingClientRect) return new Sys.UI.Point(0,0);var screenRects = element.getClientRects();if (!screenRects || !screenRects.length) {
return new Sys.UI.Point(0,0);}
var first = screenRects[0];var dLeft = 0;var dTop = 0;var inFrame = false;try {
inFrame = element.ownerDocument.parentWindow.frameElement;} catch(ex) {
inFrame = true;}
if (inFrame) {
var clientRect = element.getBoundingClientRect();if (!clientRect) {
return new Sys.UI.Point(0,0);}
var minLeft = first.left;var minTop = first.top;for (var i = 1;i < screenRects.length;i++) {
var r = screenRects[i];if (r.left < minLeft) {
minLeft = r.left;}
if (r.top < minTop) {
minTop = r.top;}
}
dLeft = minLeft - clientRect.left;dTop = minTop - clientRect.top;}
var ownerDocument = element.document.documentElement;return new Sys.UI.Point(first.left - 2 - dLeft + ownerDocument.scrollLeft, first.top - 2 - dTop + ownerDocument.scrollTop);}
return Sys.UI.DomElement.getLocation(element);},
setLocation : function(element, point) {
Sys.UI.DomElement.setLocation(element, point.x, point.y);},
getContentSize : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var size = this.getSize(element);var borderBox = this.getBorderBox(element);var paddingBox = this.getPaddingBox(element);return {
width : size.width - borderBox.horizontal - paddingBox.horizontal,
height : size.height - borderBox.vertical - paddingBox.vertical
}
},
getSize : function(element) {
if (!element) {
throw Error.argumentNull('element');}
return {
width: element.offsetWidth,
height: element.offsetHeight
};},
setContentSize : function(element, size) {
if (!element) {
throw Error.argumentNull('element');}
if (!size) {
throw Error.argumentNull('size');}
if(this.getCurrentStyle(element, 'MozBoxSizing') == 'border-box' || this.getCurrentStyle(element, 'BoxSizing') == 'border-box') {
var borderBox = this.getBorderBox(element);var paddingBox = this.getPaddingBox(element);size = {
width: size.width + borderBox.horizontal + paddingBox.horizontal,
height: size.height + borderBox.vertical + paddingBox.vertical
};}
element.style.width = size.width.toString() + 'px';element.style.height = size.height.toString() + 'px';},
setSize : function(element, size) {
if (!element) {
throw Error.argumentNull('element');}
if (!size) {
throw Error.argumentNull('size');}
var borderBox = this.getBorderBox(element);var paddingBox = this.getPaddingBox(element);var contentSize = {
width: size.width - borderBox.horizontal - paddingBox.horizontal,
height: size.height - borderBox.vertical - paddingBox.vertical
};this.setContentSize(element, contentSize);},
getBounds : function(element) {
var offset = $common.getLocation(element);return new Sys.UI.Bounds(offset.x, offset.y, element.offsetWidth || 0, element.offsetHeight || 0);}, 
setBounds : function(element, bounds) {
if (!element) {
throw Error.argumentNull('element');}
if (!bounds) {
throw Error.argumentNull('bounds');}
this.setSize(element, bounds);$common.setLocation(element, bounds);},
getClientBounds : function() {
var clientWidth;var clientHeight;switch(Sys.Browser.agent) {
case Sys.Browser.InternetExplorer:
if (document.documentElement && document.documentElement.clientWidth)
clientWidth = document.documentElement.clientWidth;else if (document.body)
clientWidth = document.body.clientWidth;if (document.documentElement && document.documentElement.clientHeight)
clientHeight = document.documentElement.clientHeight;else if (document.body)
clientHeight = document.body.clientHeight;break;case Sys.Browser.Safari:
clientWidth = window.innerWidth;clientHeight = window.innerHeight;break;case Sys.Browser.Opera:
clientWidth = Math.min(window.innerWidth, document.body.clientWidth);clientHeight = Math.min(window.innerHeight, document.body.clientHeight);break;default: 
clientWidth = Math.min(window.innerWidth, document.documentElement.clientWidth);clientHeight = Math.min(window.innerHeight, document.documentElement.clientHeight);break;}
return new Sys.UI.Bounds(0, 0, clientWidth, clientHeight);},
getMarginBox : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var box = {
top: this.getMargin(element, AjaxControlToolkit.BoxSide.Top),
right: this.getMargin(element, AjaxControlToolkit.BoxSide.Right),
bottom: this.getMargin(element, AjaxControlToolkit.BoxSide.Bottom),
left: this.getMargin(element, AjaxControlToolkit.BoxSide.Left)
};box.horizontal = box.left + box.right;box.vertical = box.top + box.bottom;return box;},
getBorderBox : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var box = {
top: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Top),
right: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Right),
bottom: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Bottom),
left: this.getBorderWidth(element, AjaxControlToolkit.BoxSide.Left)
};box.horizontal = box.left + box.right;box.vertical = box.top + box.bottom;return box;},
getPaddingBox : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var box = {
top: this.getPadding(element, AjaxControlToolkit.BoxSide.Top),
right: this.getPadding(element, AjaxControlToolkit.BoxSide.Right),
bottom: this.getPadding(element, AjaxControlToolkit.BoxSide.Bottom),
left: this.getPadding(element, AjaxControlToolkit.BoxSide.Left)
};box.horizontal = box.left + box.right;box.vertical = box.top + box.bottom;return box;},
isBorderVisible : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
var styleName = this._borderStyleNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);return styleValue != "none";},
getMargin : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
var styleName = this._marginWidthNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);try { return this.parsePadding(styleValue);} catch(ex) { return 0;}
},
getBorderWidth : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
if(!this.isBorderVisible(element, boxSide)) {
return 0;} 
var styleName = this._borderWidthNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);return this.parseBorderWidth(styleValue);},
getPadding : function(element, boxSide) {
if (!element) {
throw Error.argumentNull('element');}
if(boxSide < AjaxControlToolkit.BoxSide.Top || boxSide > AjaxControlToolkit.BoxSide.Left) {
throw Error.argumentOutOfRange(String.format(Sys.Res.enumInvalidValue, boxSide, 'AjaxControlToolkit.BoxSide'));}
var styleName = this._paddingWidthNames[boxSide];var styleValue = this.getCurrentStyle(element, styleName);return this.parsePadding(styleValue);},
parseBorderWidth : function(borderWidth) {
if (!this._borderThicknesses) {
var borderThicknesses = { };var div0 = document.createElement('div');div0.style.visibility = 'hidden';div0.style.position = 'absolute';div0.style.fontSize = '1px';document.body.appendChild(div0)
var div1 = document.createElement('div');div1.style.height = '0px';div1.style.overflow = 'hidden';div0.appendChild(div1);var base = div0.offsetHeight;div1.style.borderTop = 'solid black';div1.style.borderTopWidth = 'thin';borderThicknesses['thin'] = div0.offsetHeight - base;div1.style.borderTopWidth = 'medium';borderThicknesses['medium'] = div0.offsetHeight - base;div1.style.borderTopWidth = 'thick';borderThicknesses['thick'] = div0.offsetHeight - base;div0.removeChild(div1);document.body.removeChild(div0);this._borderThicknesses = borderThicknesses;}
if (borderWidth) {
switch(borderWidth) {
case 'thin':
case 'medium':
case 'thick':
return this._borderThicknesses[borderWidth];case 'inherit':
return 0;}
var unit = this.parseUnit(borderWidth);Sys.Debug.assert(unit.type == 'px', String.format(AjaxControlToolkit.Resources.Common_InvalidBorderWidthUnit, unit.type));return unit.size;}
return 0;},
parsePadding : function(padding) {
if(padding) {
if(padding == 'inherit') {
return 0;}
var unit = this.parseUnit(padding);Sys.Debug.assert(unit.type == 'px', String.format(AjaxControlToolkit.Resources.Common_InvalidPaddingUnit, unit.type));return unit.size;}
return 0;},
parseUnit : function(value) {
if (!value) {
throw Error.argumentNull('value');}
value = value.trim().toLowerCase();var l = value.length;var s = -1;for(var i = 0;i < l;i++) {
var ch = value.substr(i, 1);if((ch < '0' || ch > '9') && ch != '-' && ch != '.' && ch != ',') {
break;}
s = i;}
if(s == -1) {
throw Error.create(AjaxControlToolkit.Resources.Common_UnitHasNoDigits);}
var type;var size;if(s < (l - 1)) {
type = value.substring(s + 1).trim();} else {
type = 'px';}
size = parseFloat(value.substr(0, s + 1));if(type == 'px') {
size = Math.floor(size);}
return { 
size: size,
type: type
};},
getElementOpacity : function(element) {
if (!element) {
throw Error.argumentNull('element');}
var hasOpacity = false;var opacity;if (element.filters) {
var filters = element.filters;if (filters.length !== 0) {
var alphaFilter = filters['DXImageTransform.Microsoft.Alpha'];if (alphaFilter) {
opacity = alphaFilter.opacity / 100.0;hasOpacity = true;}
}
}
else {
opacity = this.getCurrentStyle(element, 'opacity', 1);hasOpacity = true;}
if (hasOpacity === false) {
return 1.0;}
return parseFloat(opacity);},
setElementOpacity : function(element, value) {
if (!element) {
throw Error.argumentNull('element');}
if (element.filters) {
var filters = element.filters;var createFilter = true;if (filters.length !== 0) {
var alphaFilter = filters['DXImageTransform.Microsoft.Alpha'];if (alphaFilter) {
createFilter = false;alphaFilter.opacity = value * 100;}
}
if (createFilter) {
element.style.filter = 'progid:DXImageTransform.Microsoft.Alpha(opacity=' + (value * 100) + ')';}
}
else {
element.style.opacity = value;}
},
getVisible : function(element) {
return (element &&
("none" != $common.getCurrentStyle(element, "display")) &&
("hidden" != $common.getCurrentStyle(element, "visibility")));},
setVisible : function(element, value) {
if (element && value != $common.getVisible(element)) {
if (value) {
if (element.style.removeAttribute) {
element.style.removeAttribute("display");} else {
element.style.removeProperty("display");}
} else {
element.style.display = 'none';}
element.style.visibility = value ? 'visible' : 'hidden';}
},
resolveFunction : function(value) {
if (value) {
if (value instanceof Function) {
return value;} else if (String.isInstanceOfType(value) && value.length > 0) {
var func;if ((func = window[value]) instanceof Function) {
return func;} else if ((func = eval(value)) instanceof Function) {
return func;}
}
}
return null;},
addCssClasses : function(element, classNames) {
for(var i = 0;i < classNames.length;i++) {
Sys.UI.DomElement.addCssClass(element, classNames[i]);}
},
removeCssClasses : function(element, classNames) {
for(var i = 0;i < classNames.length;i++) {
Sys.UI.DomElement.removeCssClass(element, classNames[i]);}
},
setStyle : function(element, style) {
$common.applyProperties(element.style, style);},
removeHandlers : function(element, events) {
for (var name in events) {
$removeHandler(element, name, events[name]);}
},
overlaps : function(r1, r2) {
return r1.x < (r2.x + r2.width)
&& r2.x < (r1.x + r1.width)
&& r1.y < (r2.y + r2.height)
&& r2.y < (r1.y + r1.height);},
containsPoint : function(rect, x, y) {
return x >= rect.x && x < (rect.x + rect.width) && y >= rect.y && y < (rect.y + rect.height);},
isKeyDigit : function(keyCode) { 
return (0x30 <= keyCode && keyCode <= 0x39);},
isKeyNavigation : function(keyCode) { 
return (Sys.UI.Key.left <= keyCode && keyCode <= Sys.UI.Key.down);},
padLeft : function(text, size, ch, truncate) { 
return $common._pad(text, size || 2, ch || ' ', 'l', truncate || false);},
padRight : function(text, size, ch, truncate) { 
return $common._pad(text, size || 2, ch || ' ', 'r', truncate || false);},
_pad : function(text, size, ch, side, truncate) {
text = text.toString();var length = text.length;var builder = new Sys.StringBuilder();if (side == 'r') {
builder.append(text);} 
while (length < size) {
builder.append(ch);length++;}
if (side == 'l') {
builder.append(text);}
var result = builder.toString();if (truncate && result.length > size) {
if (side == 'l') {
result = result.substr(result.length - size, size);} else {
result = result.substr(0, size);}
}
return result;},
__DOMEvents : {
focusin : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("focusin", true, false, window, 1);} },
focusout : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("focusout", true, false, window, 1);} },
activate : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("activate", true, true, window, 1);} },
focus : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("focus", false, false, window, 1);} },
blur : { eventGroup : "UIEvents", init : function(e, p) { e.initUIEvent("blur", false, false, window, 1);} },
click : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("click", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
dblclick : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("click", true, true, window, 2, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mousedown : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mousedown", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mouseup : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mouseup", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mouseover : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mouseover", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mousemove : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mousemove", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
mouseout : { eventGroup : "MouseEvents", init : function(e, p) { e.initMouseEvent("mousemove", true, true, window, 1, p.screenX || 0, p.screenY || 0, p.clientX || 0, p.clientY || 0, p.ctrlKey || false, p.altKey || false, p.shiftKey || false, p.metaKey || false, p.button || 0, p.relatedTarget || null);} },
load : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("load", false, false);} },
unload : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("unload", false, false);} },
select : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("select", true, false);} },
change : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("change", true, false);} },
submit : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("submit", true, true);} },
reset : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("reset", true, false);} },
resize : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("resize", true, false);} },
scroll : { eventGroup : "HTMLEvents", init : function(e, p) { e.initEvent("scroll", true, false);} }
},
tryFireRawEvent : function(element, rawEvent) {
try {
if (element.fireEvent) {
element.fireEvent("on" + rawEvent.type, rawEvent);return true;} else if (element.dispatchEvent) {
element.dispatchEvent(rawEvent);return true;}
} catch (e) {
}
return false;}, 
tryFireEvent : function(element, eventName, properties) {
try {
if (document.createEventObject) {
var e = document.createEventObject();$common.applyProperties(e, properties || {});element.fireEvent("on" + eventName, e);return true;} else if (document.createEvent) {
var def = $common.__DOMEvents[eventName];if (def) {
var e = document.createEvent(def.eventGroup);def.init(e, properties || {});element.dispatchEvent(e);return true;}
}
} catch (e) {
}
return false;},
wrapElement : function(innerElement, newOuterElement, newInnerParentElement) {
var parent = innerElement.parentNode;parent.replaceChild(newOuterElement, innerElement);(newInnerParentElement || newOuterElement).appendChild(innerElement);},
unwrapElement : function(innerElement, oldOuterElement) {
var parent = oldOuterElement.parentNode;if (parent != null) {
$common.removeElement(innerElement);parent.replaceChild(innerElement, oldOuterElement);}
},
removeElement : function(element) {
var parent = element.parentNode;if (parent != null) {
parent.removeChild(element);}
},
applyProperties : function(target, properties) {
for (var p in properties) {
var pv = properties[p];if (pv != null && Object.getType(pv)===Object) {
var tv = target[p];$common.applyProperties(tv, pv);} else {
target[p] = pv;}
}
},
createElementFromTemplate : function(template, appendToParent, nameTable) {
if (typeof(template.nameTable)!='undefined') {
var newNameTable = template.nameTable;if (String.isInstanceOfType(newNameTable)) {
newNameTable = nameTable[newNameTable];}
if (newNameTable != null) {
nameTable = newNameTable;}
}
var elementName = null;if (typeof(template.name)!=='undefined') {
elementName = template.name;}
var elt = document.createElement(template.nodeName);if (typeof(template.name)!=='undefined' && nameTable) {
nameTable[template.name] = elt;}
if (typeof(template.parent)!=='undefined' && appendToParent == null) {
var newParent = template.parent;if (String.isInstanceOfType(newParent)) {
newParent = nameTable[newParent];}
if (newParent != null) {
appendToParent = newParent;}
}
if (typeof(template.properties)!=='undefined' && template.properties != null) {
$common.applyProperties(elt, template.properties);}
if (typeof(template.cssClasses)!=='undefined' && template.cssClasses != null) {
$common.addCssClasses(elt, template.cssClasses);}
if (typeof(template.events)!=='undefined' && template.events != null) {
$addHandlers(elt, template.events);}
if (typeof(template.visible)!=='undefined' && template.visible != null) {
this.setVisible(elt, template.visible);}
if (appendToParent) {
appendToParent.appendChild(elt);}
if (typeof(template.opacity)!=='undefined' && template.opacity != null) {
$common.setElementOpacity(elt, template.opacity);}
if (typeof(template.children)!=='undefined' && template.children != null) {
for (var i = 0;i < template.children.length;i++) {
var subtemplate = template.children[i];$common.createElementFromTemplate(subtemplate, elt, nameTable);}
}
var contentPresenter = elt;if (typeof(template.contentPresenter)!=='undefined' && template.contentPresenter != null) {
contentPresenter = nameTable[contentPresenter];}
if (typeof(template.content)!=='undefined' && template.content != null) {
var content = template.content;if (String.isInstanceOfType(content)) {
content = nameTable[content];}
if (content.parentNode) {
$common.wrapElement(content, elt, contentPresenter);} else {
contentPresenter.appendChild(content);}
}
return elt;},
prepareHiddenElementForATDeviceUpdate : function () {
var objHidden = document.getElementById('hiddenInputToUpdateATBuffer_CommonToolkitScripts');if (!objHidden) {
var objHidden = document.createElement('input');objHidden.setAttribute('type', 'hidden');objHidden.setAttribute('value', '1');objHidden.setAttribute('id', 'hiddenInputToUpdateATBuffer_CommonToolkitScripts');objHidden.setAttribute('name', 'hiddenInputToUpdateATBuffer_CommonToolkitScripts');if ( document.forms[0] ) {
document.forms[0].appendChild(objHidden);}
}
},
updateFormToRefreshATDeviceBuffer : function () {
var objHidden = document.getElementById('hiddenInputToUpdateATBuffer_CommonToolkitScripts');if (objHidden) {
if (objHidden.getAttribute('value') == '1') {
objHidden.setAttribute('value', '0');} else {
objHidden.setAttribute('value', '1');}
}
}
}
var CommonToolkitScripts = AjaxControlToolkit.CommonToolkitScripts = new AjaxControlToolkit._CommonToolkitScripts();var $common = CommonToolkitScripts;Sys.UI.DomElement.getVisible = $common.getVisible;Sys.UI.DomElement.setVisible = $common.setVisible;Sys.UI.Control.overlaps = $common.overlaps;AjaxControlToolkit._DomUtility = function() {
}
AjaxControlToolkit._DomUtility.prototype = {
isDescendant : function(ancestor, descendant) {
for (var n = descendant.parentNode;n != null;n = n.parentNode) {
if (n == ancestor) return true;}
return false;},
isDescendantOrSelf : function(ancestor, descendant) {
if (ancestor === descendant) 
return true;return AjaxControlToolkit.DomUtility.isDescendant(ancestor, descendant);},
isAncestor : function(descendant, ancestor) {
return AjaxControlToolkit.DomUtility.isDescendant(ancestor, descendant);},
isAncestorOrSelf : function(descendant, ancestor) {
if (descendant === ancestor)
return true;return AjaxControlToolkit.DomUtility.isDescendant(ancestor, descendant);},
isSibling : function(self, sibling) {
var parent = self.parentNode;for (var i = 0;i < parent.childNodes.length;i++) {
if (parent.childNodes[i] == sibling) return true;}
return false;}
}
AjaxControlToolkit._DomUtility.registerClass("AjaxControlToolkit._DomUtility");AjaxControlToolkit.DomUtility = new AjaxControlToolkit._DomUtility();AjaxControlToolkit.TextBoxWrapper = function(element) {
AjaxControlToolkit.TextBoxWrapper.initializeBase(this, [element]);this._current = element.value;this._watermark = null;this._isWatermarked = false;}
AjaxControlToolkit.TextBoxWrapper.prototype = {
dispose : function() {
this.get_element().AjaxControlToolkitTextBoxWrapper = null;AjaxControlToolkit.TextBoxWrapper.callBaseMethod(this, 'dispose');},
get_Current : function() {
this._current = this.get_element().value;return this._current;},
set_Current : function(value) {
this._current = value;this._updateElement();},
get_Value : function() {
if (this.get_IsWatermarked()) {
return "";} else {
return this.get_Current();}
},
set_Value : function(text) {
this.set_Current(text);if (!text || (0 == text.length)) {
if (null != this._watermark) {
this.set_IsWatermarked(true);}
} else {
this.set_IsWatermarked(false);}
},
get_Watermark : function() {
return this._watermark;},
set_Watermark : function(value) {
this._watermark = value;this._updateElement();},
get_IsWatermarked : function() {
return this._isWatermarked;},
set_IsWatermarked : function(isWatermarked) {
if (this._isWatermarked != isWatermarked) {
this._isWatermarked = isWatermarked;this._updateElement();this._raiseWatermarkChanged();}
},
_updateElement : function() {
var element = this.get_element();if (this._isWatermarked) {
if (element.value != this._watermark) {
element.value = this._watermark;}
} else {
if (element.value != this._current) {
element.value = this._current;}
}
},
add_WatermarkChanged : function(handler) {
this.get_events().addHandler("WatermarkChanged", handler);},
remove_WatermarkChanged : function(handler) {
this.get_events().removeHandler("WatermarkChanged", handler);},
_raiseWatermarkChanged : function() {
var onWatermarkChangedHandler = this.get_events().getHandler("WatermarkChanged");if (onWatermarkChangedHandler) {
onWatermarkChangedHandler(this, Sys.EventArgs.Empty);}
}
}
AjaxControlToolkit.TextBoxWrapper.get_Wrapper = function(element) {
if (null == element.AjaxControlToolkitTextBoxWrapper) {
element.AjaxControlToolkitTextBoxWrapper = new AjaxControlToolkit.TextBoxWrapper(element);}
return element.AjaxControlToolkitTextBoxWrapper;}
AjaxControlToolkit.TextBoxWrapper.registerClass('AjaxControlToolkit.TextBoxWrapper', Sys.UI.Behavior);AjaxControlToolkit.TextBoxWrapper.validatorGetValue = function(id) {
var control = $get(id);if (control && control.AjaxControlToolkitTextBoxWrapper) {
return control.AjaxControlToolkitTextBoxWrapper.get_Value();}
return AjaxControlToolkit.TextBoxWrapper._originalValidatorGetValue(id);}
if (typeof(ValidatorGetValue) == 'function') {
AjaxControlToolkit.TextBoxWrapper._originalValidatorGetValue = ValidatorGetValue;ValidatorGetValue = AjaxControlToolkit.TextBoxWrapper.validatorGetValue;}
if (Sys.CultureInfo.prototype._getAbbrMonthIndex) {
try {
Sys.CultureInfo.prototype._getAbbrMonthIndex('');} catch(ex) {
Sys.CultureInfo.prototype._getAbbrMonthIndex = function(value) {
if (!this._upperAbbrMonths) {
this._upperAbbrMonths = this._toUpperArray(this.dateTimeFormat.AbbreviatedMonthNames);}
return Array.indexOf(this._upperAbbrMonths, this._toUpper(value));}
Sys.CultureInfo.CurrentCulture._getAbbrMonthIndex = Sys.CultureInfo.prototype._getAbbrMonthIndex;Sys.CultureInfo.InvariantCulture._getAbbrMonthIndex = Sys.CultureInfo.prototype._getAbbrMonthIndex;}
}

//END AjaxControlToolkit.Common.Common.js
//START AjaxControlToolkit.Compat.Timer.Timer.js
/////////////////////////////////////////////////////////////////////////////
Sys.Timer = function() {
Sys.Timer.initializeBase(this);this._interval = 1000;this._enabled = false;this._timer = null;}
Sys.Timer.prototype = {
get_interval: function() {
return this._interval;},
set_interval: function(value) {
if (this._interval !== value) {
this._interval = value;this.raisePropertyChanged('interval');if (!this.get_isUpdating() && (this._timer !== null)) {
this._stopTimer();this._startTimer();}
}
},
get_enabled: function() {
return this._enabled;},
set_enabled: function(value) {
if (value !== this.get_enabled()) {
this._enabled = value;this.raisePropertyChanged('enabled');if (!this.get_isUpdating()) {
if (value) {
this._startTimer();}
else {
this._stopTimer();}
}
}
},
add_tick: function(handler) {
this.get_events().addHandler("tick", handler);},
remove_tick: function(handler) {
this.get_events().removeHandler("tick", handler);},
dispose: function() {
this.set_enabled(false);this._stopTimer();Sys.Timer.callBaseMethod(this, 'dispose');},
updated: function() {
Sys.Timer.callBaseMethod(this, 'updated');if (this._enabled) {
this._stopTimer();this._startTimer();}
},
_timerCallback: function() {
var handler = this.get_events().getHandler("tick");if (handler) {
handler(this, Sys.EventArgs.Empty);}
},
_startTimer: function() {
this._timer = window.setInterval(Function.createDelegate(this, this._timerCallback), this._interval);},
_stopTimer: function() {
window.clearInterval(this._timer);this._timer = null;}
}
Sys.Timer.descriptor = {
properties: [ {name: 'interval', type: Number},
{name: 'enabled', type: Boolean} ],
events: [ {name: 'tick'} ]
}
Sys.Timer.registerClass('Sys.Timer', Sys.Component);
//END AjaxControlToolkit.Compat.Timer.Timer.js
//START AjaxControlToolkit.Animation.Animations.js
Type.registerNamespace('AjaxControlToolkit.Animation');var $AA = AjaxControlToolkit.Animation;$AA.registerAnimation = function(name, type) {
if (type && ((type === $AA.Animation) || (type.inheritsFrom && type.inheritsFrom($AA.Animation)))) {
if (!$AA.__animations) {
$AA.__animations = { };}
$AA.__animations[name.toLowerCase()] = type;type.play = function() {
var animation = new type();type.apply(animation, arguments);animation.initialize();var handler = Function.createDelegate(animation,
function() {
animation.remove_ended(handler);handler = null;animation.dispose();});animation.add_ended(handler);animation.play();}
} else {
throw Error.argumentType('type', type, $AA.Animation, AjaxControlToolkit.Resources.Animation_InvalidBaseType);}
}
$AA.buildAnimation = function(json, defaultTarget) {
if (!json || json === '') {
return null;}
var obj;json = '(' + json + ')';if (! Sys.Debug.isDebug) {
try { obj = Sys.Serialization.JavaScriptSerializer.deserialize(json);} catch (ex) { } 
} else {
obj = Sys.Serialization.JavaScriptSerializer.deserialize(json);}
return $AA.createAnimation(obj, defaultTarget);}
$AA.createAnimation = function(obj, defaultTarget) {
if (!obj || !obj.AnimationName) {
throw Error.argument('obj', AjaxControlToolkit.Resources.Animation_MissingAnimationName);}
var type = $AA.__animations[obj.AnimationName.toLowerCase()];if (!type) {
throw Error.argument('type', String.format(AjaxControlToolkit.Resources.Animation_UknownAnimationName, obj.AnimationName));}
var animation = new type();if (defaultTarget) {
animation.set_target(defaultTarget);}
if (obj.AnimationChildren && obj.AnimationChildren.length) {
if ($AA.ParentAnimation.isInstanceOfType(animation)) {
for (var i = 0;i < obj.AnimationChildren.length;i++) {
var child = $AA.createAnimation(obj.AnimationChildren[i]);if (child) {
animation.add(child);}
}
} else {
throw Error.argument('obj', String.format(AjaxControlToolkit.Resources.Animation_ChildrenNotAllowed, type.getName()));}
}
var properties = type.__animationProperties;if (!properties) {
type.__animationProperties = { };type.resolveInheritance();for (var name in type.prototype) {
if (name.startsWith('set_')) {
type.__animationProperties[name.substr(4).toLowerCase()] = name;}
}
delete type.__animationProperties['id'];properties = type.__animationProperties;}
for (var property in obj) {
var prop = property.toLowerCase();if (prop == 'animationname' || prop == 'animationchildren') {
continue;}
var value = obj[property];var setter = properties[prop];if (setter && String.isInstanceOfType(setter) && animation[setter]) {
if (! Sys.Debug.isDebug) {
try { animation[setter](value);} catch (ex) { }
} else {
animation[setter](value);}
} else {
if (prop.endsWith('script')) {
setter = properties[prop.substr(0, property.length - 6)];if (setter && String.isInstanceOfType(setter) && animation[setter]) {
animation.DynamicProperties[setter] = value;} else if ( Sys.Debug.isDebug) {
throw Error.argument('obj', String.format(AjaxControlToolkit.Resources.Animation_NoDynamicPropertyFound, property, property.substr(0, property.length - 5)));}
} else if ( Sys.Debug.isDebug) {
throw Error.argument('obj', String.format(AjaxControlToolkit.Resources.Animation_NoPropertyFound, property));}
}
}
return animation;}
$AA.Animation = function(target, duration, fps) {
$AA.Animation.initializeBase(this);this._duration = 1;this._fps = 25;this._target = null;this._tickHandler = null;this._timer = null;this._percentComplete = 0;this._percentDelta = null;this._owner = null;this._parentAnimation = null;this.DynamicProperties = { };if (target) {
this.set_target(target);}
if (duration) {
this.set_duration(duration);}
if (fps) { 
this.set_fps(fps);}
}
$AA.Animation.prototype = {
dispose : function() {
if (this._timer) {
this._timer.dispose();this._timer = null;}
this._tickHandler = null;this._target = null;$AA.Animation.callBaseMethod(this, 'dispose');},
play : function() {
if (!this._owner) {
var resume = true;if (!this._timer) {
resume = false;if (!this._tickHandler) {
this._tickHandler = Function.createDelegate(this, this._onTimerTick);}
this._timer = new Sys.Timer();this._timer.add_tick(this._tickHandler);this.onStart();this._timer.set_interval(1000 / this._fps);this._percentDelta = 100 / (this._duration * this._fps);this._updatePercentComplete(0, true);}
this._timer.set_enabled(true);this.raisePropertyChanged('isPlaying');if (!resume) {
this.raisePropertyChanged('isActive');}
}
},
pause : function() {
if (!this._owner) {
if (this._timer) {
this._timer.set_enabled(false);this.raisePropertyChanged('isPlaying');}
}
},
stop : function(finish) {
if (!this._owner) {
var t = this._timer;this._timer = null;if (t) {
t.dispose();if (this._percentComplete !== 100) {
this._percentComplete = 100;this.raisePropertyChanged('percentComplete');if (finish || finish === undefined) {
this.onStep(100);}
}
this.onEnd();this.raisePropertyChanged('isPlaying');this.raisePropertyChanged('isActive');}
}
},
onStart : function() {
this.raiseStarted();for (var property in this.DynamicProperties) {
try {
this[property](eval(this.DynamicProperties[property]));} catch(ex) {
if ( Sys.Debug.isDebug) {
throw ex;}
}
}
},
onStep : function(percentage) {
this.setValue(this.getAnimatedValue(percentage));},
onEnd : function() {
this.raiseEnded();},
getAnimatedValue : function(percentage) {
throw Error.notImplemented();},
setValue : function(value) {
throw Error.notImplemented();},
interpolate : function(start, end, percentage) {
return start + (end - start) * (percentage / 100);},
_onTimerTick : function() {
this._updatePercentComplete(this._percentComplete + this._percentDelta, true);},
_updatePercentComplete : function(percentComplete, animate) {
if (percentComplete > 100) {
percentComplete = 100;}
this._percentComplete = percentComplete;this.raisePropertyChanged('percentComplete');if (animate) {
this.onStep(percentComplete);}
if (percentComplete === 100) {
this.stop(false);}
},
setOwner : function(owner) {
this._owner = owner;},
raiseStarted : function() {
var handlers = this.get_events().getHandler('started');if (handlers) {
handlers(this, Sys.EventArgs.Empty);}
},
add_started : function(handler) {
this.get_events().addHandler("started", handler);},
remove_started : function(handler) {
this.get_events().removeHandler("started", handler);},
raiseEnded : function() {
var handlers = this.get_events().getHandler('ended');if (handlers) {
handlers(this, Sys.EventArgs.Empty);}
},
add_ended : function(handler) {
this.get_events().addHandler("ended", handler);},
remove_ended : function(handler) {
this.get_events().removeHandler("ended", handler);},
get_target : function() {
if (!this._target && this._parentAnimation) {
return this._parentAnimation.get_target();}
return this._target;},
set_target : function(value) {
if (this._target != value) {
this._target = value;this.raisePropertyChanged('target');}
},
set_animationTarget : function(id) {
var target = null;var element = $get(id);if (element) {
target = element;} else {
var ctrl = $find(id);if (ctrl) {
element = ctrl.get_element();if (element) {
target = element;}
}
}
if (target) { 
this.set_target(target);} else {
throw Error.argument('id', String.format(AjaxControlToolkit.Resources.Animation_TargetNotFound, id));}
},
get_duration : function() {
return this._duration;},
set_duration : function(value) {
value = this._getFloat(value);if (this._duration != value) {
this._duration = value;this.raisePropertyChanged('duration');}
},
get_fps : function() {
return this._fps;},
set_fps : function(value) {
value = this._getInteger(value);if (this.fps != value) {
this._fps = value;this.raisePropertyChanged('fps');}
},
get_isActive : function() {
return (this._timer !== null);},
get_isPlaying : function() {
return (this._timer !== null) && this._timer.get_enabled();},
get_percentComplete : function() {
return this._percentComplete;},
_getBoolean : function(value) {
if (String.isInstanceOfType(value)) {
return Boolean.parse(value);}
return value;},
_getInteger : function(value) {
if (String.isInstanceOfType(value)) {
return parseInt(value);}
return value;},
_getFloat : function(value) {
if (String.isInstanceOfType(value)) {
return parseFloat(value);}
return value;},
_getEnum : function(value, type) {
if (String.isInstanceOfType(value) && type && type.parse) {
return type.parse(value);}
return value;}
}
$AA.Animation.registerClass('AjaxControlToolkit.Animation.Animation', Sys.Component);$AA.registerAnimation('animation', $AA.Animation);$AA.ParentAnimation = function(target, duration, fps, animations) {
$AA.ParentAnimation.initializeBase(this, [target, duration, fps]);this._animations = [];if (animations && animations.length) {
for (var i = 0;i < animations.length;i++) {
this.add(animations[i]);}
}
}
$AA.ParentAnimation.prototype = {
initialize : function() {
$AA.ParentAnimation.callBaseMethod(this, 'initialize');if (this._animations) {
for (var i = 0;i < this._animations.length;i++) {
var animation = this._animations[i];if (animation && !animation.get_isInitialized) {
animation.initialize();}
}
}
},
dispose : function() {
this.clear();this._animations = null;$AA.ParentAnimation.callBaseMethod(this, 'dispose');},
get_animations : function() {
return this._animations;},
add : function(animation) {
if (this._animations) {
if (animation) {
animation._parentAnimation = this;}
Array.add(this._animations, animation);this.raisePropertyChanged('animations');}
},
remove : function(animation) {
if (this._animations) {
if (animation) {
animation.dispose();}
Array.remove(this._animations, animation);this.raisePropertyChanged('animations');}
},
removeAt : function(index) {
if (this._animations) {
var animation = this._animations[index];if (animation) {
animation.dispose();}
Array.removeAt(this._animations, index);this.raisePropertyChanged('animations');}
},
clear : function() {
if (this._animations) {
for (var i = this._animations.length - 1;i >= 0;i--) {
this._animations[i].dispose();this._animations[i] = null;}
Array.clear(this._animations);this._animations = [];this.raisePropertyChanged('animations');}
}
}
$AA.ParentAnimation.registerClass('AjaxControlToolkit.Animation.ParentAnimation', $AA.Animation);$AA.registerAnimation('parent', $AA.ParentAnimation);$AA.ParallelAnimation = function(target, duration, fps, animations) {
$AA.ParallelAnimation.initializeBase(this, [target, duration, fps, animations]);}
$AA.ParallelAnimation.prototype = {
add : function(animation) {
$AA.ParallelAnimation.callBaseMethod(this, 'add', [animation]);animation.setOwner(this);},
onStart : function() {
$AA.ParallelAnimation.callBaseMethod(this, 'onStart');var animations = this.get_animations();for (var i = 0;i < animations.length;i++) {
animations[i].onStart();}
},
onStep : function(percentage) {
var animations = this.get_animations();for (var i = 0;i < animations.length;i++) {
animations[i].onStep(percentage);}
},
onEnd : function() {
var animations = this.get_animations();for (var i = 0;i < animations.length;i++) {
animations[i].onEnd();}
$AA.ParallelAnimation.callBaseMethod(this, 'onEnd');}
}
$AA.ParallelAnimation.registerClass('AjaxControlToolkit.Animation.ParallelAnimation', $AA.ParentAnimation);$AA.registerAnimation('parallel', $AA.ParallelAnimation);$AA.SequenceAnimation = function(target, duration, fps, animations, iterations) {
$AA.SequenceAnimation.initializeBase(this, [target, duration, fps, animations]);this._handler = null;this._paused = false;this._playing = false;this._index = 0;this._remainingIterations = 0;this._iterations = (iterations !== undefined) ? iterations : 1;}
$AA.SequenceAnimation.prototype = {
dispose : function() {
this._handler = null;$AA.SequenceAnimation.callBaseMethod(this, 'dispose');},
stop : function() {
if (this._playing) {
var animations = this.get_animations();if (this._index < animations.length) {
animations[this._index].remove_ended(this._handler);for (var i = this._index;i < animations.length;i++) {
animations[i].stop();}
}
this._playing = false;this._paused = false;this.raisePropertyChanged('isPlaying');this.onEnd();}
},
pause : function() {
if (this.get_isPlaying()) {
var current = this.get_animations()[this._index];if (current != null) {
current.pause();}
this._paused = true;this.raisePropertyChanged('isPlaying');}
},
play : function() {
var animations = this.get_animations();if (!this._playing) {
this._playing = true;if (this._paused) {
this._paused = false;var current = animations[this._index];if (current != null) {
current.play();this.raisePropertyChanged('isPlaying');}
} else {
this.onStart();this._index = 0;var first = animations[this._index];if (first) {
first.add_ended(this._handler);first.play();this.raisePropertyChanged('isPlaying');} else {
this.stop();}
}
}
},
onStart : function() {
$AA.SequenceAnimation.callBaseMethod(this, 'onStart');this._remainingIterations = this._iterations - 1;if (!this._handler) {
this._handler = Function.createDelegate(this, this._onEndAnimation);}
},
_onEndAnimation : function() {
var animations = this.get_animations();var current = animations[this._index++];if (current) {
current.remove_ended(this._handler);}
if (this._index < animations.length) {
var next = animations[this._index];next.add_ended(this._handler);next.play();} else if (this._remainingIterations >= 1 || this._iterations <= 0) {
this._remainingIterations--;this._index = 0;var first = animations[0];first.add_ended(this._handler);first.play();} else {
this.stop();}
},
onStep : function(percentage) {
throw Error.invalidOperation(AjaxControlToolkit.Resources.Animation_CannotNestSequence);},
onEnd : function() {
this._remainingIterations = 0;$AA.SequenceAnimation.callBaseMethod(this, 'onEnd');},
get_isActive : function() {
return true;},
get_isPlaying : function() {
return this._playing && !this._paused;},
get_iterations : function() {
return this._iterations;},
set_iterations : function(value) {
value = this._getInteger(value);if (this._iterations != value) {
this._iterations = value;this.raisePropertyChanged('iterations');}
},
get_isInfinite : function() {
return this._iterations <= 0;}
}
$AA.SequenceAnimation.registerClass('AjaxControlToolkit.Animation.SequenceAnimation', $AA.ParentAnimation);$AA.registerAnimation('sequence', $AA.SequenceAnimation);$AA.SelectionAnimation = function(target, duration, fps, animations) {
$AA.SelectionAnimation.initializeBase(this, [target, duration, fps, animations]);this._selectedIndex = -1;this._selected = null;}
$AA.SelectionAnimation.prototype = { 
getSelectedIndex : function() {
throw Error.notImplemented();},
onStart : function() {
$AA.SelectionAnimation.callBaseMethod(this, 'onStart');var animations = this.get_animations();this._selectedIndex = this.getSelectedIndex();if (this._selectedIndex >= 0 && this._selectedIndex < animations.length) {
this._selected = animations[this._selectedIndex];if (this._selected) {
this._selected.setOwner(this);this._selected.onStart();}
}
},
onStep : function(percentage) {
if (this._selected) {
this._selected.onStep(percentage);}
},
onEnd : function() {
if (this._selected) {
this._selected.onEnd();this._selected.setOwner(null);}
this._selected = null;this._selectedIndex = null;$AA.SelectionAnimation.callBaseMethod(this, 'onEnd');}
}
$AA.SelectionAnimation.registerClass('AjaxControlToolkit.Animation.SelectionAnimation', $AA.ParentAnimation);$AA.registerAnimation('selection', $AA.SelectionAnimation);$AA.ConditionAnimation = function(target, duration, fps, animations, conditionScript) {
$AA.ConditionAnimation.initializeBase(this, [target, duration, fps, animations]);this._conditionScript = conditionScript;}
$AA.ConditionAnimation.prototype = { 
getSelectedIndex : function() {
var selected = -1;if (this._conditionScript && this._conditionScript.length > 0) {
try {
selected = eval(this._conditionScript) ? 0 : 1;} catch(ex) {
}
}
return selected;},
get_conditionScript : function() {
return this._conditionScript;},
set_conditionScript : function(value) {
if (this._conditionScript != value) {
this._conditionScript = value;this.raisePropertyChanged('conditionScript');}
}
}
$AA.ConditionAnimation.registerClass('AjaxControlToolkit.Animation.ConditionAnimation', $AA.SelectionAnimation);$AA.registerAnimation('condition', $AA.ConditionAnimation);$AA.CaseAnimation = function(target, duration, fps, animations, selectScript) {
$AA.CaseAnimation.initializeBase(this, [target, duration, fps, animations]);this._selectScript = selectScript;}
$AA.CaseAnimation.prototype = {
getSelectedIndex : function() {
var selected = -1;if (this._selectScript && this._selectScript.length > 0) {
try {
var result = eval(this._selectScript)
if (result !== undefined)
selected = result;} catch (ex) {
}
}
return selected;},
get_selectScript : function() {
return this._selectScript;},
set_selectScript : function(value) {
if (this._selectScript != value) {
this._selectScript = value;this.raisePropertyChanged('selectScript');}
}
}
$AA.CaseAnimation.registerClass('AjaxControlToolkit.Animation.CaseAnimation', $AA.SelectionAnimation);$AA.registerAnimation('case', $AA.CaseAnimation);$AA.FadeEffect = function() {
throw Error.invalidOperation();}
$AA.FadeEffect.prototype = {
FadeIn : 0,
FadeOut : 1
}
$AA.FadeEffect.registerEnum("AjaxControlToolkit.Animation.FadeEffect", false);$AA.FadeAnimation = function(target, duration, fps, effect, minimumOpacity, maximumOpacity, forceLayoutInIE) {
$AA.FadeAnimation.initializeBase(this, [target, duration, fps]);this._effect = (effect !== undefined) ? effect : $AA.FadeEffect.FadeIn;this._max = (maximumOpacity !== undefined) ? maximumOpacity : 1;this._min = (minimumOpacity !== undefined) ? minimumOpacity : 0;this._start = this._min;this._end = this._max;this._layoutCreated = false;this._forceLayoutInIE = (forceLayoutInIE === undefined || forceLayoutInIE === null) ? true : forceLayoutInIE;this._currentTarget = null;this._resetOpacities();}
$AA.FadeAnimation.prototype = {
_resetOpacities : function() {
if (this._effect == $AA.FadeEffect.FadeIn) {
this._start = this._min;this._end = this._max;} else {
this._start = this._max;this._end = this._min;}
},
_createLayout : function() {
var element = this._currentTarget;if (element) {
var originalWidth = $common.getCurrentStyle(element, 'width');var originalHeight = $common.getCurrentStyle(element, 'height');var originalBackColor = $common.getCurrentStyle(element, 'backgroundColor');if ((!originalWidth || originalWidth == '' || originalWidth == 'auto') &&
(!originalHeight || originalHeight == '' || originalHeight == 'auto')) {
element.style.width = element.offsetWidth + 'px';}
if (!originalBackColor || originalBackColor == '' || originalBackColor == 'transparent' || originalBackColor == 'rgba(0, 0, 0, 0)') {
element.style.backgroundColor = $common.getInheritedBackgroundColor(element);}
this._layoutCreated = true;}
},
onStart : function() {
$AA.FadeAnimation.callBaseMethod(this, 'onStart');this._currentTarget = this.get_target();this.setValue(this._start);if (this._forceLayoutInIE && !this._layoutCreated && Sys.Browser.agent == Sys.Browser.InternetExplorer) {
this._createLayout();}
},
getAnimatedValue : function(percentage) {
return this.interpolate(this._start, this._end, percentage);},
setValue : function(value) {
if (this._currentTarget) {
$common.setElementOpacity(this._currentTarget, value);}
},
get_effect : function() {
return this._effect;},
set_effect : function(value) {
value = this._getEnum(value, $AA.FadeEffect);if (this._effect != value) {
this._effect = value;this._resetOpacities();this.raisePropertyChanged('effect');}
},
get_minimumOpacity : function() {
return this._min;},
set_minimumOpacity : function(value) {
value = this._getFloat(value);if (this._min != value) {
this._min = value;this._resetOpacities();this.raisePropertyChanged('minimumOpacity');}
},
get_maximumOpacity : function() {
return this._max;},
set_maximumOpacity : function(value) {
value = this._getFloat(value);if (this._max != value) {
this._max = value;this._resetOpacities();this.raisePropertyChanged('maximumOpacity');}
},
get_forceLayoutInIE : function() {
return this._forceLayoutInIE;},
set_forceLayoutInIE : function(value) {
value = this._getBoolean(value);if (this._forceLayoutInIE != value) {
this._forceLayoutInIE = value;this.raisePropertyChanged('forceLayoutInIE');}
},
set_startValue : function(value) {
value = this._getFloat(value);this._start = value;}
}
$AA.FadeAnimation.registerClass('AjaxControlToolkit.Animation.FadeAnimation', $AA.Animation);$AA.registerAnimation('fade', $AA.FadeAnimation);$AA.FadeInAnimation = function(target, duration, fps, minimumOpacity, maximumOpacity, forceLayoutInIE) {
$AA.FadeInAnimation.initializeBase(this, [target, duration, fps, $AA.FadeEffect.FadeIn, minimumOpacity, maximumOpacity, forceLayoutInIE]);}
$AA.FadeInAnimation.prototype = {
onStart : function() {
$AA.FadeInAnimation.callBaseMethod(this, 'onStart');if (this._currentTarget) {
this.set_startValue($common.getElementOpacity(this._currentTarget));}
}
}
$AA.FadeInAnimation.registerClass('AjaxControlToolkit.Animation.FadeInAnimation', $AA.FadeAnimation);$AA.registerAnimation('fadeIn', $AA.FadeInAnimation);$AA.FadeOutAnimation = function(target, duration, fps, minimumOpacity, maximumOpacity, forceLayoutInIE) {
$AA.FadeOutAnimation.initializeBase(this, [target, duration, fps, $AA.FadeEffect.FadeOut, minimumOpacity, maximumOpacity, forceLayoutInIE]);}
$AA.FadeOutAnimation.prototype = {
onStart : function() {
$AA.FadeOutAnimation.callBaseMethod(this, 'onStart');if (this._currentTarget) {
this.set_startValue($common.getElementOpacity(this._currentTarget));}
}
}
$AA.FadeOutAnimation.registerClass('AjaxControlToolkit.Animation.FadeOutAnimation', $AA.FadeAnimation);$AA.registerAnimation('fadeOut', $AA.FadeOutAnimation);$AA.PulseAnimation = function(target, duration, fps, iterations, minimumOpacity, maximumOpacity, forceLayoutInIE) {
$AA.PulseAnimation.initializeBase(this, [target, duration, fps, null, ((iterations !== undefined) ? iterations : 3)]);this._out = new $AA.FadeOutAnimation(target, duration, fps, minimumOpacity, maximumOpacity, forceLayoutInIE);this.add(this._out);this._in = new $AA.FadeInAnimation(target, duration, fps, minimumOpacity, maximumOpacity, forceLayoutInIE);this.add(this._in);}
$AA.PulseAnimation.prototype = {
get_minimumOpacity : function() {
return this._out.get_minimumOpacity();},
set_minimumOpacity : function(value) {
value = this._getFloat(value);this._out.set_minimumOpacity(value);this._in.set_minimumOpacity(value);this.raisePropertyChanged('minimumOpacity');},
get_maximumOpacity : function() {
return this._out.get_maximumOpacity();},
set_maximumOpacity : function(value) {
value = this._getFloat(value);this._out.set_maximumOpacity(value);this._in.set_maximumOpacity(value);this.raisePropertyChanged('maximumOpacity');},
get_forceLayoutInIE : function() {
return this._out.get_forceLayoutInIE();},
set_forceLayoutInIE : function(value) {
value = this._getBoolean(value);this._out.set_forceLayoutInIE(value);this._in.set_forceLayoutInIE(value);this.raisePropertyChanged('forceLayoutInIE');},
set_duration : function(value) {
value = this._getFloat(value);$AA.PulseAnimation.callBaseMethod(this, 'set_duration', [value]);this._in.set_duration(value);this._out.set_duration(value);},
set_fps : function(value) {
value = this._getInteger(value);$AA.PulseAnimation.callBaseMethod(this, 'set_fps', [value]);this._in.set_fps(value);this._out.set_fps(value);}
}
$AA.PulseAnimation.registerClass('AjaxControlToolkit.Animation.PulseAnimation', $AA.SequenceAnimation);$AA.registerAnimation('pulse', $AA.PulseAnimation);$AA.PropertyAnimation = function(target, duration, fps, property, propertyKey) {
$AA.PropertyAnimation.initializeBase(this, [target, duration, fps]);this._property = property;this._propertyKey = propertyKey;this._currentTarget = null;}
$AA.PropertyAnimation.prototype = {
onStart : function() {
$AA.PropertyAnimation.callBaseMethod(this, 'onStart');this._currentTarget = this.get_target();},
setValue : function(value) {
var element = this._currentTarget;if (element && this._property && this._property.length > 0) { 
if (this._propertyKey && this._propertyKey.length > 0 && element[this._property]) {
element[this._property][this._propertyKey] = value;} else {
element[this._property] = value;}
}
},
getValue : function() {
var element = this.get_target();if (element && this._property && this._property.length > 0) { 
var property = element[this._property];if (property) {
if (this._propertyKey && this._propertyKey.length > 0) {
return property[this._propertyKey];}
return property;}
}
return null;},
get_property : function() {
return this._property;},
set_property : function(value) {
if (this._property != value) {
this._property = value;this.raisePropertyChanged('property');}
},
get_propertyKey : function() {
return this._propertyKey;},
set_propertyKey : function(value) {
if (this._propertyKey != value) {
this._propertyKey = value;this.raisePropertyChanged('propertyKey');}
}
}
$AA.PropertyAnimation.registerClass('AjaxControlToolkit.Animation.PropertyAnimation', $AA.Animation);$AA.registerAnimation('property', $AA.PropertyAnimation);$AA.DiscreteAnimation = function(target, duration, fps, property, propertyKey, values) {
$AA.DiscreteAnimation.initializeBase(this, [target, duration, fps, property, propertyKey]);this._values = (values && values.length) ? values : [];}
$AA.DiscreteAnimation.prototype = {
getAnimatedValue : function(percentage) {
var index = Math.floor(this.interpolate(0, this._values.length - 1, percentage));return this._values[index];},
get_values : function() {
return this._values;},
set_values : function(value) {
if (this._values != value) {
this._values = value;this.raisePropertyChanged('values');}
}
}
$AA.DiscreteAnimation.registerClass('AjaxControlToolkit.Animation.DiscreteAnimation', $AA.PropertyAnimation);$AA.registerAnimation('discrete', $AA.DiscreteAnimation);$AA.InterpolatedAnimation = function(target, duration, fps, property, propertyKey, startValue, endValue) {
$AA.InterpolatedAnimation.initializeBase(this, [target, duration, fps, ((property !== undefined) ? property : 'style'), propertyKey]);this._startValue = startValue;this._endValue = endValue;}
$AA.InterpolatedAnimation.prototype = {
get_startValue : function() {
return this._startValue;},
set_startValue : function(value) {
value = this._getFloat(value);if (this._startValue != value) {
this._startValue = value;this.raisePropertyChanged('startValue');}
},
get_endValue : function() {
return this._endValue;},
set_endValue : function(value) {
value = this._getFloat(value);if (this._endValue != value) {
this._endValue = value;this.raisePropertyChanged('endValue');}
} 
}
$AA.InterpolatedAnimation.registerClass('AjaxControlToolkit.Animation.InterpolatedAnimation', $AA.PropertyAnimation);$AA.registerAnimation('interpolated', $AA.InterpolatedAnimation);$AA.ColorAnimation = function(target, duration, fps, property, propertyKey, startValue, endValue) {
$AA.ColorAnimation.initializeBase(this, [target, duration, fps, property, propertyKey, startValue, endValue]);this._start = null;this._end = null;this._interpolateRed = false;this._interpolateGreen = false;this._interpolateBlue = false;}
$AA.ColorAnimation.prototype = {
onStart : function() {
$AA.ColorAnimation.callBaseMethod(this, 'onStart');this._start = $AA.ColorAnimation.getRGB(this.get_startValue());this._end = $AA.ColorAnimation.getRGB(this.get_endValue());this._interpolateRed = (this._start.Red != this._end.Red);this._interpolateGreen = (this._start.Green != this._end.Green);this._interpolateBlue = (this._start.Blue != this._end.Blue);},
getAnimatedValue : function(percentage) {
var r = this._start.Red;var g = this._start.Green;var b = this._start.Blue;if (this._interpolateRed)
r = Math.round(this.interpolate(r, this._end.Red, percentage));if (this._interpolateGreen)
g = Math.round(this.interpolate(g, this._end.Green, percentage));if (this._interpolateBlue)
b = Math.round(this.interpolate(b, this._end.Blue, percentage));return $AA.ColorAnimation.toColor(r, g, b);},
set_startValue : function(value) {
if (this._startValue != value) {
this._startValue = value;this.raisePropertyChanged('startValue');}
},
set_endValue : function(value) {
if (this._endValue != value) {
this._endValue = value;this.raisePropertyChanged('endValue');}
} 
}
$AA.ColorAnimation.getRGB = function(color) {
if (!color || color.length != 7) {
throw String.format(AjaxControlToolkit.Resources.Animation_InvalidColor, color);}
return { 'Red': parseInt(color.substr(1,2), 16),
'Green': parseInt(color.substr(3,2), 16),
'Blue': parseInt(color.substr(5,2), 16) };}
$AA.ColorAnimation.toColor = function(red, green, blue) {
var r = red.toString(16);var g = green.toString(16);var b = blue.toString(16);if (r.length == 1) r = '0' + r;if (g.length == 1) g = '0' + g;if (b.length == 1) b = '0' + b;return '#' + r + g + b;}
$AA.ColorAnimation.registerClass('AjaxControlToolkit.Animation.ColorAnimation', $AA.InterpolatedAnimation);$AA.registerAnimation('color', $AA.ColorAnimation);$AA.LengthAnimation = function(target, duration, fps, property, propertyKey, startValue, endValue, unit) {
$AA.LengthAnimation.initializeBase(this, [target, duration, fps, property, propertyKey, startValue, endValue]);this._unit = (unit != null) ? unit : 'px';}
$AA.LengthAnimation.prototype = {
getAnimatedValue : function(percentage) {
var value = this.interpolate(this.get_startValue(), this.get_endValue(), percentage);return Math.round(value) + this._unit;},
get_unit : function() {
return this._unit;},
set_unit : function(value) {
if (this._unit != value) {
this._unit = value;this.raisePropertyChanged('unit');}
}
}
$AA.LengthAnimation.registerClass('AjaxControlToolkit.Animation.LengthAnimation', $AA.InterpolatedAnimation);$AA.registerAnimation('length', $AA.LengthAnimation);$AA.MoveAnimation = function(target, duration, fps, horizontal, vertical, relative, unit) {
$AA.MoveAnimation.initializeBase(this, [target, duration, fps, null]);this._horizontal = horizontal ? horizontal : 0;this._vertical = vertical ? vertical : 0;this._relative = (relative === undefined) ? true : relative;this._horizontalAnimation = new $AA.LengthAnimation(target, duration, fps, 'style', 'left', null, null, unit);this._verticalAnimation = new $AA.LengthAnimation(target, duration, fps, 'style', 'top', null, null, unit);this.add(this._verticalAnimation);this.add(this._horizontalAnimation);}
$AA.MoveAnimation.prototype = {
onStart : function() {
$AA.MoveAnimation.callBaseMethod(this, 'onStart');var element = this.get_target();this._horizontalAnimation.set_startValue(element.offsetLeft);this._horizontalAnimation.set_endValue(this._relative ? element.offsetLeft + this._horizontal : this._horizontal);this._verticalAnimation.set_startValue(element.offsetTop);this._verticalAnimation.set_endValue(this._relative ? element.offsetTop + this._vertical : this._vertical);},
get_horizontal : function() {
return this._horizontal;},
set_horizontal : function(value) {
value = this._getFloat(value);if (this._horizontal != value) {
this._horizontal = value;this.raisePropertyChanged('horizontal');}
},
get_vertical : function() {
return this._vertical;},
set_vertical : function(value) {
value = this._getFloat(value);if (this._vertical != value) {
this._vertical = value;this.raisePropertyChanged('vertical');}
},
get_relative : function() {
return this._relative;},
set_relative : function(value) {
value = this._getBoolean(value);if (this._relative != value) {
this._relative = value;this.raisePropertyChanged('relative');}
},
get_unit : function() {
this._horizontalAnimation.get_unit();},
set_unit : function(value) {
var unit = this._horizontalAnimation.get_unit();if (unit != value) {
this._horizontalAnimation.set_unit(value);this._verticalAnimation.set_unit(value);this.raisePropertyChanged('unit');}
}
}
$AA.MoveAnimation.registerClass('AjaxControlToolkit.Animation.MoveAnimation', $AA.ParallelAnimation);$AA.registerAnimation('move', $AA.MoveAnimation);$AA.ResizeAnimation = function(target, duration, fps, width, height, unit) {
$AA.ResizeAnimation.initializeBase(this, [target, duration, fps, null]);this._width = width;this._height = height;this._horizontalAnimation = new $AA.LengthAnimation(target, duration, fps, 'style', 'width', null, null, unit);this._verticalAnimation = new $AA.LengthAnimation(target, duration, fps, 'style', 'height', null, null, unit);this.add(this._horizontalAnimation);this.add(this._verticalAnimation);}
$AA.ResizeAnimation.prototype = {
onStart : function() {
$AA.ResizeAnimation.callBaseMethod(this, 'onStart');var element = this.get_target();this._horizontalAnimation.set_startValue(element.offsetWidth);this._verticalAnimation.set_startValue(element.offsetHeight);this._horizontalAnimation.set_endValue((this._width !== null && this._width !== undefined) ?
this._width : element.offsetWidth);this._verticalAnimation.set_endValue((this._height !== null && this._height !== undefined) ?
this._height : element.offsetHeight);},
get_width : function() {
return this._width;},
set_width : function(value) {
value = this._getFloat(value);if (this._width != value) {
this._width = value;this.raisePropertyChanged('width');}
},
get_height : function() {
return this._height;},
set_height : function(value) {
value = this._getFloat(value);if (this._height != value) {
this._height = value;this.raisePropertyChanged('height');}
},
get_unit : function() {
this._horizontalAnimation.get_unit();},
set_unit : function(value) {
var unit = this._horizontalAnimation.get_unit();if (unit != value) {
this._horizontalAnimation.set_unit(value);this._verticalAnimation.set_unit(value);this.raisePropertyChanged('unit');}
}
}
$AA.ResizeAnimation.registerClass('AjaxControlToolkit.Animation.ResizeAnimation', $AA.ParallelAnimation);$AA.registerAnimation('resize', $AA.ResizeAnimation);$AA.ScaleAnimation = function(target, duration, fps, scaleFactor, unit, center, scaleFont, fontUnit) {
$AA.ScaleAnimation.initializeBase(this, [target, duration, fps]);this._scaleFactor = (scaleFactor !== undefined) ? scaleFactor : 1;this._unit = (unit !== undefined) ? unit : 'px';this._center = center;this._scaleFont = scaleFont;this._fontUnit = (fontUnit !== undefined) ? fontUnit : 'pt';this._element = null;this._initialHeight = null;this._initialWidth = null;this._initialTop = null;this._initialLeft = null;this._initialFontSize = null;}
$AA.ScaleAnimation.prototype = { 
getAnimatedValue : function(percentage) {
return this.interpolate(1.0, this._scaleFactor, percentage);},
onStart : function() {
$AA.ScaleAnimation.callBaseMethod(this, 'onStart');this._element = this.get_target();if (this._element) {
this._initialHeight = this._element.offsetHeight;this._initialWidth = this._element.offsetWidth;if (this._center) {
this._initialTop = this._element.offsetTop;this._initialLeft = this._element.offsetLeft;}
if (this._scaleFont) {
this._initialFontSize = parseFloat(
$common.getCurrentStyle(this._element, 'fontSize'));}
}
},
setValue : function(scale) {
if (this._element) {
var width = Math.round(this._initialWidth * scale);var height = Math.round(this._initialHeight * scale);this._element.style.width = width + this._unit;this._element.style.height = height + this._unit;if (this._center) {
this._element.style.top = (this._initialTop +
Math.round((this._initialHeight - height) / 2)) + this._unit;this._element.style.left = (this._initialLeft +
Math.round((this._initialWidth - width) / 2)) + this._unit;}
if (this._scaleFont) {
var size = this._initialFontSize * scale;if (this._fontUnit == 'px' || this._fontUnit == 'pt') {
size = Math.round(size);}
this._element.style.fontSize = size + this._fontUnit;}
}
},
onEnd : function() {
this._element = null;this._initialHeight = null;this._initialWidth = null;this._initialTop = null;this._initialLeft = null;this._initialFontSize = null;$AA.ScaleAnimation.callBaseMethod(this, 'onEnd');},
get_scaleFactor : function() {
return this._scaleFactor;},
set_scaleFactor : function(value) {
value = this._getFloat(value);if (this._scaleFactor != value) {
this._scaleFactor = value;this.raisePropertyChanged('scaleFactor');}
},
get_unit : function() {
return this._unit;},
set_unit : function(value) {
if (this._unit != value) {
this._unit = value;this.raisePropertyChanged('unit');}
},
get_center : function() {
return this._center;},
set_center : function(value) {
value = this._getBoolean(value);if (this._center != value) {
this._center = value;this.raisePropertyChanged('center');}
},
get_scaleFont : function() {
return this._scaleFont;},
set_scaleFont : function(value) {
value = this._getBoolean(value);if (this._scaleFont != value) {
this._scaleFont = value;this.raisePropertyChanged('scaleFont');}
},
get_fontUnit : function() {
return this._fontUnit;},
set_fontUnit : function(value) {
if (this._fontUnit != value) { 
this._fontUnit = value;this.raisePropertyChanged('fontUnit');}
}
}
$AA.ScaleAnimation.registerClass('AjaxControlToolkit.Animation.ScaleAnimation', $AA.Animation);$AA.registerAnimation('scale', $AA.ScaleAnimation);$AA.Action = function(target, duration, fps) {
$AA.Action.initializeBase(this, [target, duration, fps]);if (duration === undefined) {
this.set_duration(0);}
}
$AA.Action.prototype = {
onEnd : function() {
this.doAction();$AA.Action.callBaseMethod(this, 'onEnd');},
doAction : function() {
throw Error.notImplemented();},
getAnimatedValue : function() {
},
setValue : function() {
}
}
$AA.Action.registerClass('AjaxControlToolkit.Animation.Action', $AA.Animation);$AA.registerAnimation('action', $AA.Action);$AA.EnableAction = function(target, duration, fps, enabled) {
$AA.EnableAction.initializeBase(this, [target, duration, fps]);this._enabled = (enabled !== undefined) ? enabled : true;}
$AA.EnableAction.prototype = {
doAction : function() {
var element = this.get_target();if (element) {
element.disabled = !this._enabled;}
},
get_enabled : function() {
return this._enabled;},
set_enabled : function(value) {
value = this._getBoolean(value);if (this._enabled != value) {
this._enabled = value;this.raisePropertyChanged('enabled');}
}
}
$AA.EnableAction.registerClass('AjaxControlToolkit.Animation.EnableAction', $AA.Action);$AA.registerAnimation('enableAction', $AA.EnableAction);$AA.HideAction = function(target, duration, fps, visible) {
$AA.HideAction.initializeBase(this, [target, duration, fps]);this._visible = visible;}
$AA.HideAction.prototype = {
doAction : function() {
var element = this.get_target();if (element) {
$common.setVisible(element, this._visible);}
},
get_visible : function() {
return this._visible;},
set_visible : function(value) {
if (this._visible != value) {
this._visible = value;this.raisePropertyChanged('visible');}
}
}
$AA.HideAction.registerClass('AjaxControlToolkit.Animation.HideAction', $AA.Action);$AA.registerAnimation('hideAction', $AA.HideAction);$AA.StyleAction = function(target, duration, fps, attribute, value) {
$AA.StyleAction.initializeBase(this, [target, duration, fps]);this._attribute = attribute;this._value = value;}
$AA.StyleAction.prototype = {
doAction : function() {
var element = this.get_target();if (element) {
element.style[this._attribute] = this._value;}
},
get_attribute : function() {
return this._attribute;},
set_attribute : function(value) {
if (this._attribute != value) {
this._attribute = value;this.raisePropertyChanged('attribute');}
},
get_value : function() {
return this._value;},
set_value : function(value) {
if (this._value != value) {
this._value = value;this.raisePropertyChanged('value');}
}
}
$AA.StyleAction.registerClass('AjaxControlToolkit.Animation.StyleAction', $AA.Action);$AA.registerAnimation('styleAction', $AA.StyleAction);$AA.OpacityAction = function(target, duration, fps, opacity) {
$AA.OpacityAction.initializeBase(this, [target, duration, fps]);this._opacity = opacity;}
$AA.OpacityAction.prototype = {
doAction : function() {
var element = this.get_target();if (element) {
$common.setElementOpacity(element, this._opacity);}
},
get_opacity : function() {
return this._opacity;},
set_opacity : function(value) {
value = this._getFloat(value);if (this._opacity != value) {
this._opacity = value;this.raisePropertyChanged('opacity');}
}
}
$AA.OpacityAction.registerClass('AjaxControlToolkit.Animation.OpacityAction', $AA.Action);$AA.registerAnimation('opacityAction', $AA.OpacityAction);$AA.ScriptAction = function(target, duration, fps, script) {
$AA.ScriptAction.initializeBase(this, [target, duration, fps]);this._script = script;}
$AA.ScriptAction.prototype = {
doAction : function() {
try {
eval(this._script);} catch (ex) {
}
},
get_script : function() {
return this._script;},
set_script : function(value) {
if (this._script != value) {
this._script = value;this.raisePropertyChanged('script');}
}
}
$AA.ScriptAction.registerClass('AjaxControlToolkit.Animation.ScriptAction', $AA.Action);$AA.registerAnimation('scriptAction', $AA.ScriptAction);
//END AjaxControlToolkit.Animation.Animations.js
//START AjaxControlToolkit.ExtenderBase.BaseScripts.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.BehaviorBase = function(element) {
AjaxControlToolkit.BehaviorBase.initializeBase(this,[element]);this._clientStateFieldID = null;this._pageRequestManager = null;this._partialUpdateBeginRequestHandler = null;this._partialUpdateEndRequestHandler = null;}
AjaxControlToolkit.BehaviorBase.prototype = {
initialize : function() {
AjaxControlToolkit.BehaviorBase.callBaseMethod(this, 'initialize');},
dispose : function() {
AjaxControlToolkit.BehaviorBase.callBaseMethod(this, 'dispose');if (this._pageRequestManager) {
if (this._partialUpdateBeginRequestHandler) {
this._pageRequestManager.remove_beginRequest(this._partialUpdateBeginRequestHandler);this._partialUpdateBeginRequestHandler = null;}
if (this._partialUpdateEndRequestHandler) {
this._pageRequestManager.remove_endRequest(this._partialUpdateEndRequestHandler);this._partialUpdateEndRequestHandler = null;}
this._pageRequestManager = null;}
},
get_ClientStateFieldID : function() {
return this._clientStateFieldID;},
set_ClientStateFieldID : function(value) {
if (this._clientStateFieldID != value) {
this._clientStateFieldID = value;this.raisePropertyChanged('ClientStateFieldID');}
},
get_ClientState : function() {
if (this._clientStateFieldID) {
var input = document.getElementById(this._clientStateFieldID);if (input) {
return input.value;}
}
return null;},
set_ClientState : function(value) {
if (this._clientStateFieldID) {
var input = document.getElementById(this._clientStateFieldID);if (input) {
input.value = value;}
}
},
registerPartialUpdateEvents : function() {
if (Sys && Sys.WebForms && Sys.WebForms.PageRequestManager){
this._pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();if (this._pageRequestManager) {
this._partialUpdateBeginRequestHandler = Function.createDelegate(this, this._partialUpdateBeginRequest);this._pageRequestManager.add_beginRequest(this._partialUpdateBeginRequestHandler);this._partialUpdateEndRequestHandler = Function.createDelegate(this, this._partialUpdateEndRequest);this._pageRequestManager.add_endRequest(this._partialUpdateEndRequestHandler);}
}
},
_partialUpdateBeginRequest : function(sender, beginRequestEventArgs) {
},
_partialUpdateEndRequest : function(sender, endRequestEventArgs) {
}
}
AjaxControlToolkit.BehaviorBase.registerClass('AjaxControlToolkit.BehaviorBase', Sys.UI.Behavior);AjaxControlToolkit.DynamicPopulateBehaviorBase = function(element) {
AjaxControlToolkit.DynamicPopulateBehaviorBase.initializeBase(this, [element]);this._DynamicControlID = null;this._DynamicContextKey = null;this._DynamicServicePath = null;this._DynamicServiceMethod = null;this._cacheDynamicResults = false;this._dynamicPopulateBehavior = null;this._populatingHandler = null;this._populatedHandler = null;}
AjaxControlToolkit.DynamicPopulateBehaviorBase.prototype = {
initialize : function() {
AjaxControlToolkit.DynamicPopulateBehaviorBase.callBaseMethod(this, 'initialize');this._populatingHandler = Function.createDelegate(this, this._onPopulating);this._populatedHandler = Function.createDelegate(this, this._onPopulated);},
dispose : function() {
if (this._populatedHandler) {
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.remove_populated(this._populatedHandler);}
this._populatedHandler = null;}
if (this._populatingHandler) {
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.remove_populating(this._populatingHandler);}
this._populatingHandler = null;}
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.dispose();this._dynamicPopulateBehavior = null;}
AjaxControlToolkit.DynamicPopulateBehaviorBase.callBaseMethod(this, 'dispose');},
populate : function(contextKeyOverride) {
if (this._dynamicPopulateBehavior && (this._dynamicPopulateBehavior.get_element() != $get(this._DynamicControlID))) {
this._dynamicPopulateBehavior.dispose();this._dynamicPopulateBehavior = null;}
if (!this._dynamicPopulateBehavior && this._DynamicControlID && this._DynamicServiceMethod) {
this._dynamicPopulateBehavior = $create(AjaxControlToolkit.DynamicPopulateBehavior,
{
"id" : this.get_id() + "_DynamicPopulateBehavior",
"ContextKey" : this._DynamicContextKey,
"ServicePath" : this._DynamicServicePath,
"ServiceMethod" : this._DynamicServiceMethod,
"cacheDynamicResults" : this._cacheDynamicResults
}, null, null, $get(this._DynamicControlID));this._dynamicPopulateBehavior.add_populating(this._populatingHandler);this._dynamicPopulateBehavior.add_populated(this._populatedHandler);}
if (this._dynamicPopulateBehavior) {
this._dynamicPopulateBehavior.populate(contextKeyOverride ? contextKeyOverride : this._DynamicContextKey);}
},
_onPopulating : function(sender, eventArgs) {
this.raisePopulating(eventArgs);},
_onPopulated : function(sender, eventArgs) {
this.raisePopulated(eventArgs);},
get_dynamicControlID : function() {
return this._DynamicControlID;},
get_DynamicControlID : this.get_dynamicControlID,
set_dynamicControlID : function(value) {
if (this._DynamicControlID != value) {
this._DynamicControlID = value;this.raisePropertyChanged('dynamicControlID');this.raisePropertyChanged('DynamicControlID');}
},
set_DynamicControlID : this.set_dynamicControlID,
get_dynamicContextKey : function() {
return this._DynamicContextKey;},
get_DynamicContextKey : this.get_dynamicContextKey,
set_dynamicContextKey : function(value) {
if (this._DynamicContextKey != value) {
this._DynamicContextKey = value;this.raisePropertyChanged('dynamicContextKey');this.raisePropertyChanged('DynamicContextKey');}
},
set_DynamicContextKey : this.set_dynamicContextKey,
get_dynamicServicePath : function() {
return this._DynamicServicePath;},
get_DynamicServicePath : this.get_dynamicServicePath,
set_dynamicServicePath : function(value) {
if (this._DynamicServicePath != value) {
this._DynamicServicePath = value;this.raisePropertyChanged('dynamicServicePath');this.raisePropertyChanged('DynamicServicePath');}
},
set_DynamicServicePath : this.set_dynamicServicePath,
get_dynamicServiceMethod : function() {
return this._DynamicServiceMethod;},
get_DynamicServiceMethod : this.get_dynamicServiceMethod,
set_dynamicServiceMethod : function(value) {
if (this._DynamicServiceMethod != value) {
this._DynamicServiceMethod = value;this.raisePropertyChanged('dynamicServiceMethod');this.raisePropertyChanged('DynamicServiceMethod');}
},
set_DynamicServiceMethod : this.set_dynamicServiceMethod,
get_cacheDynamicResults : function() {
return this._cacheDynamicResults;},
set_cacheDynamicResults : function(value) {
if (this._cacheDynamicResults != value) {
this._cacheDynamicResults = value;this.raisePropertyChanged('cacheDynamicResults');}
},
add_populated : function(handler) {
this.get_events().addHandler("populated", handler);},
remove_populated : function(handler) {
this.get_events().removeHandler("populated", handler);},
raisePopulated : function(arg) {
var handler = this.get_events().getHandler("populated");if (handler) handler(this, arg);},
add_populating : function(handler) {
this.get_events().addHandler('populating', handler);},
remove_populating : function(handler) {
this.get_events().removeHandler('populating', handler);},
raisePopulating : function(eventArgs) {
var handler = this.get_events().getHandler('populating');if (handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit.DynamicPopulateBehaviorBase.registerClass('AjaxControlToolkit.DynamicPopulateBehaviorBase', AjaxControlToolkit.BehaviorBase);AjaxControlToolkit.ControlBase = function(element) {
AjaxControlToolkit.ControlBase.initializeBase(this, [element]);this._clientStateField = null;this._callbackTarget = null;this._onsubmit$delegate = Function.createDelegate(this, this._onsubmit);this._oncomplete$delegate = Function.createDelegate(this, this._oncomplete);this._onerror$delegate = Function.createDelegate(this, this._onerror);}
AjaxControlToolkit.ControlBase.prototype = {
initialize : function() {
AjaxControlToolkit.ControlBase.callBaseMethod(this, "initialize");if (this._clientStateField) {
this.loadClientState(this._clientStateField.value);}
if (typeof(Sys.WebForms)!=="undefined" && typeof(Sys.WebForms.PageRequestManager)!=="undefined") {
Array.add(Sys.WebForms.PageRequestManager.getInstance()._onSubmitStatements, this._onsubmit$delegate);} else {
$addHandler(document.forms[0], "submit", this._onsubmit$delegate);}
},
dispose : function() {
if (typeof(Sys.WebForms)!=="undefined" && typeof(Sys.WebForms.PageRequestManager)!=="undefined") {
Array.remove(Sys.WebForms.PageRequestManager.getInstance()._onSubmitStatements, this._onsubmit$delegate);} else {
$removeHandler(document.forms[0], "submit", this._onsubmit$delegate);}
AjaxControlToolkit.ControlBase.callBaseMethod(this, "dispose");},
findElement : function(id) {
return $get(this.get_id() + '_' + id.split(':').join('_'));},
get_clientStateField : function() {
return this._clientStateField;},
set_clientStateField : function(value) {
if (this.get_isInitialized()) throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_CannotSetClientStateField);if (this._clientStateField != value) {
this._clientStateField = value;this.raisePropertyChanged('clientStateField');}
},
loadClientState : function(value) {
},
saveClientState : function() {
return null;},
_invoke : function(name, args, cb) {
if (!this._callbackTarget) {
throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_ControlNotRegisteredForCallbacks);}
if (typeof(WebForm_DoCallback)==="undefined") {
throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_PageNotRegisteredForCallbacks);}
var ar = [];for (var i = 0;i < args.length;i++) 
ar[i] = args[i];var clientState = this.saveClientState();if (clientState != null && !String.isInstanceOfType(clientState)) {
throw Error.invalidOperation(AjaxControlToolkit.Resources.ExtenderBase_InvalidClientStateType);}
var payload = Sys.Serialization.JavaScriptSerializer.serialize({name:name,args:ar,state:this.saveClientState()});WebForm_DoCallback(this._callbackTarget, payload, this._oncomplete$delegate, cb, this._onerror$delegate, true);},
_oncomplete : function(result, context) {
result = Sys.Serialization.JavaScriptSerializer.deserialize(result);if (result.error) {
throw Error.create(result.error);}
this.loadClientState(result.state);context(result.result);},
_onerror : function(message, context) {
throw Error.create(message);},
_onsubmit : function() {
if (this._clientStateField) {
this._clientStateField.value = this.saveClientState();}
return true;} 
}
AjaxControlToolkit.ControlBase.registerClass("AjaxControlToolkit.ControlBase", Sys.UI.Control);
AjaxControlToolkit.Resources={
"PasswordStrength_InvalidWeightingRatios":"Strength Weighting ratios must have 4 elements","Animation_ChildrenNotAllowed":"AjaxControlToolkit.Animation.createAnimation cannot add child animations to type \"{0}\" that does not derive from AjaxControlToolkit.Animation.ParentAnimation","PasswordStrength_RemainingSymbols":"{0} symbol characters","ExtenderBase_CannotSetClientStateField":"clientStateField can only be set before initialization","RTE_PreviewHTML":"Preview HTML","RTE_JustifyCenter":"Justify Center","PasswordStrength_RemainingUpperCase":"{0} more upper case characters","Animation_TargetNotFound":"AjaxControlToolkit.Animation.Animation.set_animationTarget requires the ID of a Sys.UI.DomElement or Sys.UI.Control.  No element or control could be found corresponding to \"{0}\"","RTE_FontColor":"Font Color","RTE_LabelColor":"Label Color","Common_InvalidBorderWidthUnit":"A unit type of \"{0}\"\u0027 is invalid for parseBorderWidth","RTE_Heading":"Heading","Tabs_PropertySetBeforeInitialization":"{0} cannot be changed before initialization","RTE_OrderedList":"Ordered List","ReorderList_DropWatcherBehavior_NoChild":"Could not find child of list with id \"{0}\"","CascadingDropDown_MethodTimeout":"[Method timeout]","RTE_Columns":"Columns","RTE_InsertImage":"Insert Image","RTE_InsertTable":"Insert Table","RTE_Values":"Values","RTE_OK":"OK","ExtenderBase_PageNotRegisteredForCallbacks":"This Page has not been registered for callbacks","Animation_NoDynamicPropertyFound":"AjaxControlToolkit.Animation.createAnimation found no property corresponding to \"{0}\" or \"{1}\"","Animation_InvalidBaseType":"AjaxControlToolkit.Animation.registerAnimation can only register types that inherit from AjaxControlToolkit.Animation.Animation","RTE_UnorderedList":"Unordered List","ResizableControlBehavior_InvalidHandler":"{0} handler not a function, function name, or function text","Animation_InvalidColor":"Color must be a 7-character hex representation (e.g. #246ACF), not \"{0}\"","RTE_CellColor":"Cell Color","PasswordStrength_RemainingMixedCase":"Mixed case characters","RTE_Italic":"Italic","CascadingDropDown_NoParentElement":"Failed to find parent element \"{0}\"","ValidatorCallout_DefaultErrorMessage":"This control is invalid","RTE_Indent":"Indent","ReorderList_DropWatcherBehavior_CallbackError":"Reorder failed, see details below.\\r\\n\\r\\n{0}","PopupControl_NoDefaultProperty":"No default property supported for control \"{0}\" of type \"{1}\"","RTE_Normal":"Normal","PopupExtender_NoParentElement":"Couldn\u0027t find parent element \"{0}\"","RTE_ViewValues":"View Values","RTE_Legend":"Legend","RTE_Labels":"Labels","RTE_CellSpacing":"Cell Spacing","PasswordStrength_RemainingNumbers":"{0} more numbers","RTE_Border":"Border","RTE_Create":"Create","RTE_BackgroundColor":"Background Color","RTE_Cancel":"Cancel","RTE_JustifyFull":"Justify Full","RTE_JustifyLeft":"Justify Left","RTE_Cut":"Cut","ResizableControlBehavior_CannotChangeProperty":"Changes to {0} not supported","RTE_ViewSource":"View Source","Common_InvalidPaddingUnit":"A unit type of \"{0}\" is invalid for parsePadding","RTE_Paste":"Paste","ExtenderBase_ControlNotRegisteredForCallbacks":"This Control has not been registered for callbacks","Calendar_Today":"Today: {0}","Common_DateTime_InvalidFormat":"Invalid format","ListSearch_DefaultPrompt":"Type to search","CollapsiblePanel_NoControlID":"Failed to find element \"{0}\"","RTE_ViewEditor":"View Editor","RTE_BarColor":"Bar Color","PasswordStrength_DefaultStrengthDescriptions":"NonExistent;Very Weak;Weak;Poor;Almost OK;Barely Acceptable;Average;Good;Strong;Excellent;Unbreakable!","RTE_Inserttexthere":"Insert text here","Animation_UknownAnimationName":"AjaxControlToolkit.Animation.createAnimation could not find an Animation corresponding to the name \"{0}\"","ExtenderBase_InvalidClientStateType":"saveClientState must return a value of type String","Rating_CallbackError":"An unhandled exception has occurred:\\r\\n{0}","Tabs_OwnerExpected":"owner must be set before initialize","DynamicPopulate_WebServiceTimeout":"Web service call timed out","PasswordStrength_RemainingLowerCase":"{0} more lower case characters","Animation_MissingAnimationName":"AjaxControlToolkit.Animation.createAnimation requires an object with an AnimationName property","RTE_JustifyRight":"Justify Right","Tabs_ActiveTabArgumentOutOfRange":"Argument is not a member of the tabs collection","RTE_CellPadding":"Cell Padding","RTE_ClearFormatting":"Clear Formatting","AlwaysVisible_ElementRequired":"AjaxControlToolkit.AlwaysVisibleControlBehavior must have an element","Slider_NoSizeProvided":"Please set valid values for the height and width attributes in the slider\u0027s CSS classes","DynamicPopulate_WebServiceError":"Web Service call failed: {0}","PasswordStrength_StrengthPrompt":"Strength: ","PasswordStrength_RemainingCharacters":"{0} more characters","PasswordStrength_Satisfied":"Nothing more required","RTE_Hyperlink":"Hyperlink","Animation_NoPropertyFound":"AjaxControlToolkit.Animation.createAnimation found no property corresponding to \"{0}\"","PasswordStrength_InvalidStrengthDescriptionStyles":"Text Strength description style classes must match the number of text descriptions.","PasswordStrength_GetHelpRequirements":"Get help on password requirements","PasswordStrength_InvalidStrengthDescriptions":"Invalid number of text strength descriptions specified","RTE_Underline":"Underline","Tabs_PropertySetAfterInitialization":"{0} cannot be changed after initialization","RTE_Rows":"Rows","RTE_Redo":"Redo","RTE_Size":"Size","RTE_Undo":"Undo","RTE_Bold":"Bold","RTE_Copy":"Copy","RTE_Font":"Font","CascadingDropDown_MethodError":"[Method error {0}]","RTE_BorderColor":"Border Color","RTE_Paragraph":"Paragraph","RTE_InsertHorizontalRule":"Insert Horizontal Rule","Common_UnitHasNoDigits":"No digits","RTE_Outdent":"Outdent","Common_DateTime_InvalidTimeSpan":"\"{0}\" is not a valid TimeSpan format","Animation_CannotNestSequence":"AjaxControlToolkit.Animation.SequenceAnimation cannot be nested inside AjaxControlToolkit.Animation.ParallelAnimation","Shared_BrowserSecurityPreventsPaste":"Your browser security settings don\u0027t permit the automatic execution of paste operations. Please use the keyboard shortcut Ctrl+V instead."};
//END AjaxControlToolkit.ExtenderBase.BaseScripts.js
//START AjaxControlToolkit.Animation.AnimationBehavior.js
Type.registerNamespace('AjaxControlToolkit.Animation');AjaxControlToolkit.Animation.AnimationBehavior = function(element) {
AjaxControlToolkit.Animation.AnimationBehavior.initializeBase(this, [element]);this._onLoad = null;this._onClick = null;this._onMouseOver = null;this._onMouseOut = null;this._onHoverOver = null;this._onHoverOut = null;this._onClickHandler = null;this._onMouseOverHandler = null;this._onMouseOutHandler = null;}
AjaxControlToolkit.Animation.AnimationBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.Animation.AnimationBehavior.callBaseMethod(this, 'initialize');var element = this.get_element();if (element) {
this._onClickHandler = Function.createDelegate(this, this.OnClick);$addHandler(element, 'click', this._onClickHandler);this._onMouseOverHandler = Function.createDelegate(this, this.OnMouseOver);$addHandler(element, 'mouseover', this._onMouseOverHandler);this._onMouseOutHandler = Function.createDelegate(this, this.OnMouseOut);$addHandler(element, 'mouseout', this._onMouseOutHandler);}
},
dispose : function() {
var element = this.get_element();if (element) {
if (this._onClickHandler) {
$removeHandler(element, 'click', this._onClickHandler);this._onClickHandler = null;}
if (this._onMouseOverHandler) {
$removeHandler(element, 'mouseover', this._onMouseOverHandler);this._onMouseOverHandler = null;}
if (this._onMouseOutHandler) {
$removeHandler(element, 'mouseout', this._onMouseOutHandler);this._onMouseOutHandler = null;}
}
this._onLoad = null;this._onClick = null;this._onMouseOver = null;this._onMouseOut = null;this._onHoverOver = null;this._onHoverOut = null;AjaxControlToolkit.Animation.AnimationBehavior.callBaseMethod(this, 'dispose');},
get_OnLoad : function() {
return this._onLoad ? this._onLoad.get_json() : null;},
set_OnLoad : function(value) {
if (!this._onLoad) {
this._onLoad = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onLoad.initialize();}
this._onLoad.set_json(value);this.raisePropertyChanged('OnLoad');this._onLoad.play();},
get_OnLoadBehavior : function() {
return this._onLoad;},
get_OnClick : function() {
return this._onClick ? this._onClick.get_json() : null;},
set_OnClick : function(value) {
if (!this._onClick) {
this._onClick = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onClick.initialize();}
this._onClick.set_json(value);this.raisePropertyChanged('OnClick');},
get_OnClickBehavior : function() {
return this._onClick;},
OnClick : function() {
if (this._onClick) {
this._onClick.play();}
},
get_OnMouseOver : function() {
return this._onMouseOver ? this._onMouseOver.get_json() : null;},
set_OnMouseOver : function(value) {
if (!this._onMouseOver) {
this._onMouseOver = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onMouseOver.initialize();}
this._onMouseOver.set_json(value);this.raisePropertyChanged('OnMouseOver');},
get_OnMouseOverBehavior : function() {
return this._onMouseOver;},
OnMouseOver : function() {
if (this._onMouseOver) {
this._onMouseOver.play();}
if (this._onHoverOver) {
if (this._onHoverOut) {
this._onHoverOut.quit();}
this._onHoverOver.play();}
},
get_OnMouseOut : function() {
return this._onMouseOut ? this._onMouseOut.get_json() : null;},
set_OnMouseOut : function(value) {
if (!this._onMouseOut) {
this._onMouseOut = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onMouseOut.initialize();}
this._onMouseOut.set_json(value);this.raisePropertyChanged('OnMouseOut');},
get_OnMouseOutBehavior : function() {
return this._onMouseOut;},
OnMouseOut : function() {
if (this._onMouseOut) {
this._onMouseOut.play();}
if (this._onHoverOut) {
if (this._onHoverOver) {
this._onHoverOver.quit();}
this._onHoverOut.play();}
},
get_OnHoverOver : function() {
return this._onHoverOver ? this._onHoverOver.get_json() : null;},
set_OnHoverOver : function(value) {
if (!this._onHoverOver) {
this._onHoverOver = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onHoverOver.initialize();}
this._onHoverOver.set_json(value);this.raisePropertyChanged('OnHoverOver');},
get_OnHoverOverBehavior : function() {
return this._onHoverOver;},
get_OnHoverOut : function() {
return this._onHoverOut ? this._onHoverOut.get_json() : null;},
set_OnHoverOut : function(value) {
if (!this._onHoverOut) {
this._onHoverOut = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onHoverOut.initialize();}
this._onHoverOut.set_json(value);this.raisePropertyChanged('OnHoverOut');},
get_OnHoverOutBehavior : function() {
return this._onHoverOut;}
}
AjaxControlToolkit.Animation.AnimationBehavior.registerClass('AjaxControlToolkit.Animation.AnimationBehavior', AjaxControlToolkit.BehaviorBase);AjaxControlToolkit.Animation.GenericAnimationBehavior = function(element) {
AjaxControlToolkit.Animation.GenericAnimationBehavior.initializeBase(this, [element]);this._json = null;this._animation = null;}
AjaxControlToolkit.Animation.GenericAnimationBehavior.prototype = {
dispose : function() {
this.disposeAnimation();AjaxControlToolkit.Animation.GenericAnimationBehavior.callBaseMethod(this, 'dispose');},
disposeAnimation : function() {
if (this._animation) {
this._animation.dispose();}
this._animation = null;},
play : function() {
if (this._animation && !this._animation.get_isPlaying()) {
this.stop();this._animation.play();}
},
stop : function() {
if (this._animation) {
if (this._animation.get_isPlaying()) {
this._animation.stop(true);}
}
},
quit : function() {
if (this._animation) {
if (this._animation.get_isPlaying()) {
this._animation.stop(false);}
}
},
get_json : function() {
return this._json;},
set_json : function(value) {
if (this._json != value) {
this._json = value;this.raisePropertyChanged('json');this.disposeAnimation();var element = this.get_element();if (element) {
this._animation = AjaxControlToolkit.Animation.buildAnimation(this._json, element);if (this._animation) {
this._animation.initialize();}
this.raisePropertyChanged('animation');}
}
},
get_animation : function() {
return this._animation;}
}
AjaxControlToolkit.Animation.GenericAnimationBehavior.registerClass('AjaxControlToolkit.Animation.GenericAnimationBehavior', AjaxControlToolkit.BehaviorBase);
//END AjaxControlToolkit.Animation.AnimationBehavior.js
//START AjaxControlToolkit.PopupExtender.PopupBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.PopupBehavior = function(element) {
AjaxControlToolkit.PopupBehavior.initializeBase(this, [element]);this._x = 0;this._y = 0;this._positioningMode = AjaxControlToolkit.PositioningMode.Absolute;this._parentElement = null;this._parentElementID = null;this._moveHandler = null;this._firstPopup = true;this._originalParent = null;this._visible = false;this._onShow = null;this._onShowEndedHandler = null;this._onHide = null;this._onHideEndedHandler = null;}
AjaxControlToolkit.PopupBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.PopupBehavior.callBaseMethod(this, 'initialize');this._hidePopup();this.get_element().style.position = "absolute";this._onShowEndedHandler = Function.createDelegate(this, this._onShowEnded);this._onHideEndedHandler = Function.createDelegate(this, this._onHideEnded);},
dispose : function() {
var element = this.get_element();if (element) {
if (this._visible) {
this.hide();}
if (this._originalParent) {
element.parentNode.removeChild(element);this._originalParent.appendChild(element);this._originalParent = null;}
element._hideWindowedElementsIFrame = null;}
this._parentElement = null;if (this._onShow && this._onShow.get_animation() && this._onShowEndedHandler) {
this._onShow.get_animation().remove_ended(this._onShowEndedHandler);}
this._onShowEndedHandler = null;this._onShow = null;if (this._onHide && this._onHide.get_animation() && this._onHideEndedHandler) {
this._onHide.get_animation().remove_ended(this._onHideEndedHandler);}
this._onHideEndedHandler = null;this._onHide = null;AjaxControlToolkit.PopupBehavior.callBaseMethod(this, 'dispose');},
show : function() {
if (this._visible) {
return;}
var eventArgs = new Sys.CancelEventArgs();this.raiseShowing(eventArgs);if (eventArgs.get_cancel()) {
return;}
this._visible = true;var element = this.get_element();$common.setVisible(element, true);this.setupPopup();if (this._onShow) {
$common.setVisible(element, false);this.onShow();} else {
this.raiseShown(Sys.EventArgs.Empty);}
},
hide : function() {
if (!this._visible) {
return;}
var eventArgs = new Sys.CancelEventArgs();this.raiseHiding(eventArgs);if (eventArgs.get_cancel()) {
return;}
this._visible = false;if (this._onHide) {
this.onHide();} else {
this._hidePopup();this._hideCleanup();}
},
getBounds : function() {
var element = this.get_element();var offsetParent = element.offsetParent || document.documentElement;var diff;var parentBounds;if (this._parentElement) {
parentBounds = $common.getBounds(this._parentElement);var offsetParentLocation = $common.getLocation(offsetParent);diff = {x: parentBounds.x - offsetParentLocation.x, y:parentBounds.y - offsetParentLocation.y};} else {
parentBounds = $common.getBounds(offsetParent);diff = {x:0, y:0};}
var width = element.offsetWidth - (element.clientLeft ? element.clientLeft * 2 : 0);var height = element.offsetHeight - (element.clientTop ? element.clientTop * 2 : 0);if (this._firstpopup) {
element.style.width = width + "px";this._firstpopup = false;}
var position;switch (this._positioningMode) {
case AjaxControlToolkit.PositioningMode.Center:
position = {
x: Math.round(parentBounds.width / 2 - width / 2),
y: Math.round(parentBounds.height / 2 - height / 2)
};break;case AjaxControlToolkit.PositioningMode.BottomLeft:
position = {
x: 0,
y: parentBounds.height
};break;case AjaxControlToolkit.PositioningMode.BottomRight:
position = {
x: parentBounds.width - width,
y: parentBounds.height
};break;case AjaxControlToolkit.PositioningMode.TopLeft:
position = {
x: 0,
y: -element.offsetHeight
};break;case AjaxControlToolkit.PositioningMode.TopRight:
position = {
x: parentBounds.width - width,
y: -element.offsetHeight
};break;case AjaxControlToolkit.PositioningMode.Right:
position = {
x: parentBounds.width,
y: 0
};break;case AjaxControlToolkit.PositioningMode.Left:
position = {
x: -element.offsetWidth,
y: 0
};break;default:
position = {x: 0, y: 0};}
position.x += this._x + diff.x;position.y += this._y + diff.y;return new Sys.UI.Bounds(position.x, position.y, width, height);},
adjustPopupPosition : function(bounds) {
var element = this.get_element();if (!bounds) {
bounds = this.getBounds();}
var newPosition = $common.getBounds(element);var updateNeeded = false;if (newPosition.x < 0) {
bounds.x -= newPosition.x;updateNeeded = true;}
if (newPosition.y < 0) {
bounds.y -= newPosition.y;updateNeeded = true;}
if (updateNeeded) {
$common.setLocation(element, bounds);}
},
addBackgroundIFrame : function() {
var element = this.get_element();if ((Sys.Browser.agent === Sys.Browser.InternetExplorer) && (Sys.Browser.version < 7)) {
var childFrame = element._hideWindowedElementsIFrame;if (!childFrame) {
childFrame = document.createElement("iframe");childFrame.src = "javascript:'<html></html>';";childFrame.style.position = "absolute";childFrame.style.display = "none";childFrame.scrolling = "no";childFrame.frameBorder = "0";childFrame.tabIndex = "-1";childFrame.style.filter = "progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)";element.parentNode.insertBefore(childFrame, element);element._hideWindowedElementsIFrame = childFrame;this._moveHandler = Function.createDelegate(this, this._onMove);Sys.UI.DomEvent.addHandler(element, "move", this._moveHandler);}
$common.setBounds(childFrame, $common.getBounds(element));childFrame.style.display = element.style.display;if (element.currentStyle && element.currentStyle.zIndex) {
childFrame.style.zIndex = element.currentStyle.zIndex;} else if (element.style.zIndex) {
childFrame.style.zIndex = element.style.zIndex;}
}
},
setupPopup : function() {
var element = this.get_element();var bounds = this.getBounds();$common.setLocation(element, bounds);this.adjustPopupPosition(bounds);element.zIndex = 1000;this.addBackgroundIFrame();},
_hidePopup : function() {
var element = this.get_element();$common.setVisible(element, false);if (element.originalWidth) {
element.style.width = element.originalWidth + "px";element.originalWidth = null;}
},
_hideCleanup : function() {
var element = this.get_element();if (this._moveHandler) {
Sys.UI.DomEvent.removeHandler(element, "move", this._moveHandler);this._moveHandler = null;}
if (Sys.Browser.agent === Sys.Browser.InternetExplorer) {
var childFrame = element._hideWindowedElementsIFrame;if (childFrame) {
childFrame.style.display = "none";}
}
this.raiseHidden(Sys.EventArgs.Empty);},
_onMove : function() {
var element = this.get_element();if (element._hideWindowedElementsIFrame) {
element.parentNode.insertBefore(element._hideWindowedElementsIFrame, element);element._hideWindowedElementsIFrame.style.top = element.style.top;element._hideWindowedElementsIFrame.style.left = element.style.left;}
},
get_onShow : function() {
return this._onShow ? this._onShow.get_json() : null;},
set_onShow : function(value) {
if (!this._onShow) {
this._onShow = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onShow.initialize();}
this._onShow.set_json(value);var animation = this._onShow.get_animation();if (animation) {
animation.add_ended(this._onShowEndedHandler);}
this.raisePropertyChanged('onShow');},
get_onShowBehavior : function() {
return this._onShow;},
onShow : function() {
if (this._onShow) {
if (this._onHide) {
this._onHide.quit();}
this._onShow.play();}
},
_onShowEnded : function() {
this.adjustPopupPosition();this.addBackgroundIFrame();this.raiseShown(Sys.EventArgs.Empty);},
get_onHide : function() {
return this._onHide ? this._onHide.get_json() : null;},
set_onHide : function(value) {
if (!this._onHide) {
this._onHide = new AjaxControlToolkit.Animation.GenericAnimationBehavior(this.get_element());this._onHide.initialize();}
this._onHide.set_json(value);var animation = this._onHide.get_animation();if (animation) {
animation.add_ended(this._onHideEndedHandler);}
this.raisePropertyChanged('onHide');},
get_onHideBehavior : function() {
return this._onHide;},
onHide : function() {
if (this._onHide) {
if (this._onShow) {
this._onShow.quit();}
this._onHide.play();}
},
_onHideEnded : function() {
this._hideCleanup();},
get_parentElement : function() {
if (!this._parentElement && this._parentElementID) {
this.set_parentElement($get(this._parentElementID));Sys.Debug.assert(this._parentElement != null, String.format(AjaxControlToolkit.Resources.PopupExtender_NoParentElement, this._parentElementID));} 
return this._parentElement;},
set_parentElement : function(element) {
this._parentElement = element;this.raisePropertyChanged('parentElement');},
get_parentElementID : function() {
if (this._parentElement) {
return this._parentElement.id
}
return this._parentElementID;},
set_parentElementID : function(elementID) {
this._parentElementID = elementID;if (this.get_isInitialized()) {
this.set_parentElement($get(elementID));}
},
get_positioningMode : function() {
return this._positioningMode;},
set_positioningMode : function(mode) {
this._positioningMode = mode;this.raisePropertyChanged('positioningMode');},
get_x : function() {
return this._x;},
set_x : function(value) {
if (value != this._x) {
this._x = value;if (this._visible) {
this.setupPopup();}
this.raisePropertyChanged('x');}
},
get_y : function() {
return this._y;},
set_y : function(value) {
if (value != this._y) {
this._y = value;if (this._visible) {
this.setupPopup();}
this.raisePropertyChanged('y');}
},
get_visible : function() {
return this._visible;},
add_showing : function(handler) {
this.get_events().addHandler('showing', handler);},
remove_showing : function(handler) {
this.get_events().removeHandler('showing', handler);},
raiseShowing : function(eventArgs) {
var handler = this.get_events().getHandler('showing');if (handler) {
handler(this, eventArgs);}
},
add_shown : function(handler) {
this.get_events().addHandler('shown', handler);},
remove_shown : function(handler) {
this.get_events().removeHandler('shown', handler);},
raiseShown : function(eventArgs) {
var handler = this.get_events().getHandler('shown');if (handler) {
handler(this, eventArgs);}
}, 
add_hiding : function(handler) {
this.get_events().addHandler('hiding', handler);},
remove_hiding : function(handler) {
this.get_events().removeHandler('hiding', handler);},
raiseHiding : function(eventArgs) {
var handler = this.get_events().getHandler('hiding');if (handler) {
handler(this, eventArgs);}
},
add_hidden : function(handler) {
this.get_events().addHandler('hidden', handler);},
remove_hidden : function(handler) {
this.get_events().removeHandler('hidden', handler);},
raiseHidden : function(eventArgs) {
var handler = this.get_events().getHandler('hidden');if (handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit.PopupBehavior.registerClass('AjaxControlToolkit.PopupBehavior', AjaxControlToolkit.BehaviorBase);AjaxControlToolkit.PositioningMode = function() {
throw Error.invalidOperation();}
AjaxControlToolkit.PositioningMode.prototype = {
Absolute: 0,
Center: 1,
BottomLeft: 2,
BottomRight: 3,
TopLeft: 4,
TopRight: 5,
Right: 6,
Left: 7
}
AjaxControlToolkit.PositioningMode.registerEnum('AjaxControlToolkit.PositioningMode');
//END AjaxControlToolkit.PopupExtender.PopupBehavior.js
//START AjaxControlToolkit.ValidatorCallout.ValidatorCalloutBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.ValidatorCalloutBehavior = function AjaxControlToolkit$ValidatorCalloutBehavior(element) {
AjaxControlToolkit.ValidatorCalloutBehavior.initializeBase(this, [element]);this._warningIconImageUrl = null;this._closeImageUrl = null;this._cssClass = "ajax__validatorcallout";this._highlightCssClass = null;this._leftSide = false;this._width = "200px";this._invalid = false;this._originalValidationMethod = null;this._validationMethodOverride = null;this._elementToValidate = null;this._popupTable = null;this._errorMessageCell = null;this._calloutArrowCell = null;this._warningIconImage = null;this._closeImage = null;this._closeCellInnerDiv = null;this._popupBehavior = null;this._onShowJson = null;this._onHideJson = null;this._focusAttached = false;this._isOpen = false;this._isBuilt = false;this._focusHandler = Function.createDelegate(this, this._onfocus);this._closeClickHandler = Function.createDelegate(this, this._oncloseClick);}
AjaxControlToolkit.ValidatorCalloutBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.ValidatorCalloutBehavior.callBaseMethod(this, 'initialize');var elt = this.get_element();if(elt.evaluationfunction) {
this._originalValidationMethod = Function.createDelegate(elt, elt.evaluationfunction);this._validationMethodOverride = Function.createDelegate(this, this._onvalidate);elt.evaluationfunction = this._validationMethodOverride;}
var clientState = this.get_ClientState();if ((null != clientState) && ("" !== clientState)) {
this._ensureCallout();this.show();}
},
_ensureCallout : function() {
if (!this._isBuilt) {
var elt = this.get_element();var elementToValidate = this._elementToValidate = $get(elt.controltovalidate);var popupTableBody = document.createElement("tbody");var popupTableRow = document.createElement("tr");var calloutCell = document.createElement("td");var calloutTable = document.createElement("table");var calloutTableBody = document.createElement("tbody");var calloutTableRow = document.createElement("tr");var iconCell = document.createElement("td");var closeCell = document.createElement("td");var closeCellInnerDiv = this._closeCellInnerDiv = document.createElement("div");var popupTable = this._popupTable = document.createElement("table");var calloutArrowCell = this._calloutArrowCell = document.createElement("td");var warningIconImage = this._warningIconImage = document.createElement("img");var closeImage = this._closeImage = document.createElement("img");var errorMessageCell = this._errorMessageCell = document.createElement("td");popupTable.id = this.get_id() + "_popupTable";popupTable.cellPadding = 0;popupTable.cellSpacing = 0;popupTable.border = 0;popupTable.width = this.get_width();popupTable.className = this._cssClass;popupTableRow.className = "ajax__validatorcallout_popup_table_row";calloutCell.className = "ajax__validatorcallout_callout_cell";calloutTable.cellPadding = 0;calloutTable.cellSpacing = 0;calloutTable.border = 0;calloutTable.className = "ajax__validatorcallout_callout_table";calloutTableRow.className = "ajax__validatorcallout_callout_table_row";if (!this._leftSide) {
calloutArrowCell.className = "ajax__validatorcallout_callout_arrow_cell";} else {
calloutArrowCell.className = "ajax__validatorcallout_callout_arrow_cell_left";}
iconCell.className = "ajax__validatorcallout_icon_cell";warningIconImage.border = 0;warningIconImage.src = this.get_warningIconImageUrl();errorMessageCell.className = "ajax__validatorcallout_error_message_cell";errorMessageCell.innerHTML = this._getErrorMessage();closeCell.className = "ajax__validatorcallout_close_button_cell";closeCellInnerDiv.className = "ajax__validatorcallout_innerdiv";closeImage.src = this.get_closeImageUrl();elt.parentNode.appendChild(popupTable)
popupTable.appendChild(popupTableBody);popupTableBody.appendChild(popupTableRow);if (!this._leftSide) {
popupTableRow.appendChild(calloutCell);calloutCell.appendChild(calloutTable);calloutTable.appendChild(calloutTableBody);calloutTableBody.appendChild(calloutTableRow);calloutTableRow.appendChild(calloutArrowCell);}
popupTableRow.appendChild(iconCell);iconCell.appendChild(warningIconImage);popupTableRow.appendChild(errorMessageCell);popupTableRow.appendChild(closeCell);closeCellInnerDiv.appendChild(closeImage);closeCell.appendChild(closeCellInnerDiv);if (this._leftSide) {
popupTableRow.appendChild(calloutCell);calloutCell.appendChild(calloutTable);calloutTable.appendChild(calloutTableBody);calloutTableBody.appendChild(calloutTableRow);calloutTableRow.appendChild(calloutArrowCell);}
var div = document.createElement("div");if (!this._leftSide) {
div.className = "ajax__validatorcallout_innerdiv";} else {
div.className = "ajax__validatorcallout_innerdiv_left";}
calloutArrowCell.appendChild(div);for(var i = 14;i > 0;i--)
{
var line = document.createElement("div");line.style.width = i.toString() + "px";div.appendChild(line);}
if (!this._leftSide) {
this._popupBehavior = $create(
AjaxControlToolkit.PopupBehavior,
{
positioningMode: AjaxControlToolkit.PositioningMode.Absolute,
parentElement: elementToValidate
},
{},
null,
this._popupTable);} else {
this._popupBehavior = $create(
AjaxControlToolkit.PopupBehavior,
{
positioningMode: AjaxControlToolkit.PositioningMode.Left,
parentElement: elementToValidate
},
{},
null,
this._popupTable);}
if (this._onShowJson) {
this._popupBehavior.set_onShow(this._onShowJson);}
if (this._onHideJson) {
this._popupBehavior.set_onHide(this._onHideJson);}
$addHandler(this._closeCellInnerDiv, "click", this._closeClickHandler);this._isBuilt = true;}
},
dispose : function() {
if (this._isBuilt) {
this.hide();if (this._focusAttached) {
$removeHandler(this._elementToValidate, "focus", this._focusHandler);this._focusAttached = false;}
$removeHandler(this._closeCellInnerDiv, "click", this._closeClickHandler);this._onShowJson = null;this._onHideJson = null;if (this._popupBehavior) {
this._popupBehavior.dispose();this._popupBehavior = null;}
if (this._closeBehavior) {
this._closeBehavior.dispose();this._closeBehavior = null;}
if (this._popupTable) {
this._popupTable.parentNode.removeChild(this._popupTable);this._popupTable = null;this._errorMessageCell = null;this._elementToValidate = null;this._calloutArrowCell = null;this._warningIconImage = null;this._closeImage = null;this._closeCellInnerDiv = null;}
this._isBuilt = false;}
AjaxControlToolkit.ValidatorCalloutBehavior.callBaseMethod(this, 'dispose');}, 
_getErrorMessage : function() {
return this.get_element().errormessage || AjaxControlToolkit.Resources.ValidatorCallout_DefaultErrorMessage;},
show: function(force) {
if (force || !this.get_isOpen()) {
if (force && AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout) {
AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();}
if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
return;}
AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout = this;if (!this.get_LeftSide()) {
this._popupBehavior.set_x($common.getSize(this._elementToValidate).width);} else {
this._popupBehavior.set_x(0);}
this._popupBehavior.show();this._errorMessageCell.innerHTML = this._getErrorMessage();}
},
hide : function() {
if(AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout == this) {
AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout = null;}
if (this._isOpen || $common.getVisible(this._popupTable)) {
this._isOpen = false;this._popupBehavior.hide();}
},
_onfocus : function(e) {
if(!this._originalValidationMethod(this.get_element())) {
this._ensureCallout();if(this._highlightCssClass) {
Sys.UI.DomElement.addCssClass(this._elementToValidate, this._highlightCssClass);}
this.show(true);return false;} else {
this.hide();return true;}
},
_oncloseClick : function(e) {
this.hide();},
_onvalidate : function(val) {
if(!this._originalValidationMethod(val)) {
this._ensureCallout();if(this._highlightCssClass) {
Sys.UI.DomElement.addCssClass(this._elementToValidate, this._highlightCssClass);}
if (!this._focusAttached) {
$addHandler(this._elementToValidate, "focus", this._focusHandler);this._focusAttached = true;}
this.show(false);this._invalid = true;return false;} else {
if(this._highlightCssClass && this._invalid) {
Sys.UI.DomElement.removeCssClass(this._elementToValidate, this._highlightCssClass)
}
this._invalid = false;this.hide();return true;}
},
get_onShow : function() {
return this._popupBehavior ? this._popupBehavior.get_onShow() : this._onShowJson;},
set_onShow : function(value) {
if (this._popupBehavior) {
this._popupBehavior.set_onShow(value)
} else {
this._onShowJson = value;}
this.raisePropertyChanged('onShow');},
get_onShowBehavior : function() {
return this._popupBehavior ? this._popupBehavior.get_onShowBehavior() : null;},
onShow : function() {
if (this._popupBehavior) {
this._popupBehavior.onShow();}
},
get_onHide : function() {
return this._popupBehavior ? this._popupBehavior.get_onHide() : this._onHideJson;},
set_onHide : function(value) {
if (this._popupBehavior) {
this._popupBehavior.set_onHide(value)
} else {
this._onHideJson = value;}
this.raisePropertyChanged('onHide');},
get_onHideBehavior : function() {
return this._popupBehavior ? this._popupBehavior.get_onHideBehavior() : null;},
onHide : function() {
if (this._popupBehavior) {
this._popupBehavior.onHide();}
},
get_LeftSide: function() {
return this._leftSide;},
set_LeftSide: function(value) {
this._leftSide = value;this.raisePropertyChanged('LeftSide');},
get_warningIconImageUrl : function() {
return this._warningIconImageUrl;},
set_warningIconImageUrl : function(value) {
if (this._warningIconImageUrl != value) {
this._warningIconImageUrl = value;if (this.get_isInitialized()) {
this._warningIconImage.src = value;}
this.raisePropertyChanged("warningIconImageUrl");}
},
get_closeImageUrl : function() {
return this._closeImageUrl;},
set_closeImageUrl : function(value) {
if (this._closeImageUrl != value) {
this._closeImageUrl = value;if (this.get_isInitialized()) {
this._closeImage.src = value;}
this.raisePropertyChanged("closeImageUrl");}
},
get_width : function() {
return this._width;},
set_width : function(value) {
if (this._width != value) { 
this._width = value;if (this.get_isInitialized()) {
this._popupTable.style.width = _width;}
this.raisePropertyChanged("width");}
},
get_cssClass : function() {
return this._cssClass;},
set_cssClass : function(value) {
if (this._cssClass != value) {
this._cssClass = value;this.raisePropertyChanged("cssClass");}
},
get_highlightCssClass : function() {
return this._highlightCssClass;},
set_highlightCssClass : function(value) {
if (this._highlightCssClass != value) {
this._highlightCssClass = value;this.raisePropertyChanged("highlightCssClass");}
},
get_isOpen : function() {
return this._isOpen;}
}
AjaxControlToolkit.ValidatorCalloutBehavior.registerClass('AjaxControlToolkit.ValidatorCalloutBehavior', AjaxControlToolkit.BehaviorBase);
//END AjaxControlToolkit.ValidatorCallout.ValidatorCalloutBehavior.js
//START AjaxControlToolkit.RoundedCorners.RoundedCornersBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.BoxCorners = function() {
throw Error.invalidOperation();}
AjaxControlToolkit.BoxCorners.prototype = {
None : 0x00,
TopLeft : 0x01,
TopRight : 0x02,
BottomRight : 0x04,
BottomLeft : 0x08,
Top : 0x01 | 0x02,
Right : 0x02 | 0x04,
Bottom : 0x04 | 0x08,
Left : 0x08 | 0x01,
All : 0x01 | 0x02 | 0x04 | 0x08
}
AjaxControlToolkit.BoxCorners.registerEnum("AjaxControlToolkit.BoxCorners", true);AjaxControlToolkit.RoundedCornersBehavior = function(element) {
AjaxControlToolkit.RoundedCornersBehavior.initializeBase(this, [element]);this._corners = AjaxControlToolkit.BoxCorners.All;this._radius = 5;this._color = null;this._parentDiv = null;this._originalStyle = null;this._borderColor = null;}
AjaxControlToolkit.RoundedCornersBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.RoundedCornersBehavior.callBaseMethod(this, 'initialize');this.buildParentDiv();},
dispose : function() {
this.disposeParentDiv();AjaxControlToolkit.RoundedCornersBehavior.callBaseMethod(this, 'dispose');},
buildParentDiv : function() {
var e = this.get_element();if (!e) return;this.disposeParentDiv();var color = this.getBackgroundColor();var originalWidth = e.offsetWidth;var newParent = e.cloneNode(false);this.moveChildren(e, newParent);this._originalStyle = e.style.cssText;e.style.backgroundColor = "transparent";e.style.verticalAlign = "top";e.style.padding = "0";e.style.overflow = "";e.style.className = "";if (e.style.height) {
e.style.height = parseInt($common.getCurrentStyle(e, 'height')) + (this._radius * 2) + "px";} else {
if (!e.style.width && (0 < originalWidth)) {
e.style.width = originalWidth + "px";}
}
newParent.style.position = "";newParent.style.border = "";newParent.style.margin = "";newParent.style.width = "100%";newParent.id = "";newParent.removeAttribute("control");if (this._borderColor) {
newParent.style.borderTopStyle = "none";newParent.style.borderBottomStyle = "none";newParent.style.borderLeftStyle = "solid";newParent.style.borderRightStyle = "solid";newParent.style.borderLeftColor = this._borderColor;newParent.style.borderRightColor = this._borderColor;newParent.style.borderLeftWidth = "1px";newParent.style.borderRightWidth = "1px";if (this._radius == 0) {
newParent.style.borderTopStyle = "solid";newParent.style.borderBottomStyle = "solid";newParent.style.borderTopColor = this._borderColor;newParent.style.borderBottomColor = this._borderColor;newParent.style.borderTopWidth = "1px";newParent.style.borderBottomWidth = "1px";}
} else {
newParent.style.borderTopStyle = "none";newParent.style.borderBottomStyle = "none";newParent.style.borderLeftStyle = "none";newParent.style.borderRightStyle = "none";}
var lastDiv = null;var radius = this._radius;var lines = this._radius;var lastDelta = 0;for (var i = lines;i > 0;i--) {
var angle = Math.acos(i / radius);var delta = radius - Math.round(Math.sin(angle) * radius);var newDiv = document.createElement("DIV");newDiv.__roundedDiv = true;newDiv.style.backgroundColor = color;newDiv.style.marginLeft = delta + "px";newDiv.style.marginRight = (delta - (this._borderColor ? 2 : 0)) + "px";newDiv.style.height = "1px";newDiv.style.fontSize = "1px";newDiv.style.overflow = "hidden";if (this._borderColor) {
newDiv.style.borderLeftStyle = "solid";newDiv.style.borderRightStyle = "solid";newDiv.style.borderLeftColor = this._borderColor;newDiv.style.borderRightColor = this._borderColor;var offset = Math.max(0, lastDelta - delta - 1);newDiv.style.borderLeftWidth = (offset + 1) + "px";newDiv.style.borderRightWidth = (offset + 1) + "px";if (i == lines) {
newDiv.__roundedDivNoBorder = true;newDiv.style.backgroundColor = this._borderColor;}
}
e.insertBefore(newDiv, lastDiv);var topDiv = newDiv;newDiv = newDiv.cloneNode(true);newDiv.__roundedDiv = true;e.insertBefore(newDiv, lastDiv);var bottomDiv = newDiv;lastDiv = newDiv;lastDelta = delta;if (!this.isCornerSet(AjaxControlToolkit.BoxCorners.TopLeft)) {
topDiv.style.marginLeft = "0";if (this._borderColor) {
topDiv.style.borderLeftWidth = "1px";}
}
if (!this.isCornerSet(AjaxControlToolkit.BoxCorners.TopRight)) {
topDiv.style.marginRight = "0";if (this._borderColor) {
topDiv.style.borderRightWidth = "1px";topDiv.style.marginRight = "-2px";}
}
if (!this.isCornerSet(AjaxControlToolkit.BoxCorners.BottomLeft)) {
bottomDiv.style.marginLeft = "0";if (this._borderColor) {
bottomDiv.style.borderLeftWidth = "1px";}
}
if (!this.isCornerSet(AjaxControlToolkit.BoxCorners.BottomRight)) {
bottomDiv.style.marginRight = "0";if (this._borderColor) {
bottomDiv.style.borderRightWidth = "1px";bottomDiv.style.marginRight = "-2px";}
}
}
e.insertBefore(newParent, lastDiv);this._parentDiv = newParent;},
disposeParentDiv : function() {
if (this._parentDiv) {
var e = this.get_element();var children = e.childNodes;for (var i = children.length - 1;i >=0;i--) {
var child = children[i];if (child) {
if (child == this._parentDiv) {
this.moveChildren(child, e);}
try {
e.removeChild(child);} catch(e) {
}
}
}
if (this._originalStyle) {
e.style.cssText = this._originalStyle;this._originalStyle = null;}
this._parentDiv = null;}
},
getBackgroundColor : function() {
if (this._color) {
return this._color;}
return $common.getCurrentStyle(this.get_element(), 'backgroundColor');},
moveChildren : function(src, dest) {
var moveCount = 0;while (src.hasChildNodes()) {
var child = src.childNodes[0];child = src.removeChild(child);dest.appendChild(child);moveCount++;}
return moveCount;},
isCornerSet : function(corner) {
return (this._corners & corner) != AjaxControlToolkit.BoxCorners.None;},
setCorner : function(corner, value) {
if (value) {
this.set_Corners(this._corners | corner);} else {
this.set_Corners(this._corners & ~corner);}
},
get_Color : function() {
return this._color;},
set_Color : function(value) {
if (value != this._color) {
this._color = value;this.buildParentDiv();this.raisePropertyChanged('Color');}
},
get_Radius : function() {
return this._radius;},
set_Radius : function(value) {
if (value != this._radius) {
this._radius = value;this.buildParentDiv();this.raisePropertyChanged('Radius');}
},
get_Corners : function() {
return this._corners;},
set_Corners : function(value) {
if (value != this._corners) {
this._corners = value;this.buildParentDiv();this.raisePropertyChanged("Corners");}
},
get_BorderColor : function() {
return this._borderColor;},
set_BorderColor : function(value) {
if (value != this._borderColor) {
this._borderColor = value;this.buildParentDiv();this.raisePropertyChanged("BorderColor");}
}
}
AjaxControlToolkit.RoundedCornersBehavior.registerClass('AjaxControlToolkit.RoundedCornersBehavior', AjaxControlToolkit.BehaviorBase);
//END AjaxControlToolkit.RoundedCorners.RoundedCornersBehavior.js
//START AjaxControlToolkit.DropShadow.DropShadowBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.DropShadowBehavior = function(element) {
AjaxControlToolkit.DropShadowBehavior.initializeBase(this, [element]);this._opacity = 1.0;this._width = 5;this._shadowDiv = null;this._trackPosition = null;this._trackPositionDelay = 50;this._timer = null;this._tickHandler = null;this._roundedBehavior = null;this._shadowRoundedBehavior = null;this._rounded = false;this._radius = 5;this._lastX = null;this._lastY = null;this._lastW = null;this._lastH = null;}
AjaxControlToolkit.DropShadowBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.DropShadowBehavior.callBaseMethod(this, 'initialize');var e = this.get_element();if ($common.getCurrentStyle(e, 'position', e.style.position) != "absolute") {
e.style.position = "relative";}
if (this._rounded) {
this.setupRounded();}
if (this._trackPosition) {
this.startTimer();}
this.setShadow();},
dispose : function() {
this.stopTimer();this.disposeShadowDiv();AjaxControlToolkit.DropShadowBehavior.callBaseMethod(this, 'dispose');},
buildShadowDiv : function() {
var e = this.get_element();if (!this.get_isInitialized() || !e || !this._width) return;var div = document.createElement("DIV");div.style.backgroundColor = "black";div.style.position= "absolute";if (e.id) {
div.id = e.id + "_DropShadow";}
this._shadowDiv = div;e.parentNode.appendChild(div);if (this._rounded ) {
this._shadowDiv.style.height = Math.max(0, e.offsetHeight - (2*this._radius)) + "px";if (!this._shadowRoundedBehavior) {
this._shadowRoundedBehavior = $create(AjaxControlToolkit.RoundedCornersBehavior, {"Radius": this._radius}, null, null, this._shadowDiv);} else {
this._shadowRoundedBehavior.set_Radius(this._radius);}
} else if (this._shadowRoundedBehavior) {
this._shadowRoundedBehavior.set_Radius(0);}
if (this._opacity != 1.0) {
this.setupOpacity();}
this.setShadow(false, true);this.updateZIndex();},
disposeShadowDiv : function() {
if (this._shadowDiv) {
if (this._shadowDiv.parentNode) {
this._shadowDiv.parentNode.removeChild(this._shadowDiv);} 
this._shadowDiv = null;}
if (this._shadowRoundedBehavior) {
this._shadowRoundedBehavior.dispose();this._shadowRoundedBehavior = null;}
},
onTimerTick : function() {
this.setShadow();},
startTimer : function() {
if (!this._timer) {
if (!this._tickHandler) {
this._tickHandler = Function.createDelegate(this, this.onTimerTick);}
this._timer = new Sys.Timer();this._timer.set_interval(this._trackPositionDelay);this._timer.add_tick(this._tickHandler);this._timer.set_enabled(true);}
},
stopTimer : function() {
if (this._timer) {
this._timer.remove_tick(this._tickHandler);this._timer.set_enabled(false);this._timer.dispose();this._timer = null;}
},
setShadow : function(force, norecurse) {
var e = this.get_element();if (!this.get_isInitialized() || !e || (!this._width && !force)) return;var existingShadow = this._shadowDiv;if (!existingShadow) {
this.buildShadowDiv();}
var location = $common.getLocation(e);if (force || this._lastX != location.x || this._lastY != location.y || !existingShadow) {
this._lastX = location.x;this._lastY = location.y;var w = this.get_Width();if((e.parentNode.style.position == "absolute") || (e.parentNode.style.position == "fixed") )
{
location.x = w;location.y = w;}
else if (e.parentNode.style.position == "relative")
{
location.x = w;var paddingTop = e.parentNode.style.paddingTop;paddingTop = paddingTop.replace("px", "");var intPaddingTop = 0;intPaddingTop = parseInt(paddingTop);location.y = w + intPaddingTop;}
else
{
location.x += w;location.y += w;}
$common.setLocation(this._shadowDiv, location);}
var h = e.offsetHeight;var w = e.offsetWidth;if (force || h != this._lastH || w != this._lastW || !existingShadow) {
this._lastW = w;this._lastH = h;if (!this._rounded || !existingShadow || norecurse) {
this._shadowDiv.style.width = w + "px";this._shadowDiv.style.height = h + "px";} else {
this.disposeShadowDiv();this.setShadow();}
}
if (this._shadowDiv) {
this._shadowDiv.style.visibility = $common.getCurrentStyle(e, 'visibility');}
},
setupOpacity : function() {
if (this.get_isInitialized() && this._shadowDiv) {
$common.setElementOpacity(this._shadowDiv, this._opacity);}
},
setupRounded : function() {
if (!this._roundedBehavior && this._rounded) {
this._roundedBehavior = $create(AjaxControlToolkit.RoundedCornersBehavior, null, null, null, this.get_element());}
if (this._roundedBehavior) {
this._roundedBehavior.set_Radius(this._rounded ? this._radius : 0);}
},
updateZIndex : function() {
if (!this._shadowDiv) return;var e = this.get_element();var targetZIndex = e.style.zIndex;var shadowZIndex = this._shadowDiv.style.zIndex;if (shadowZIndex && targetZIndex && targetZIndex > shadowZIndex) {
return;} else {
targetZIndex = Math.max(2, targetZIndex);shadowZIndex = targetZIndex - 1;}
e.style.zIndex = targetZIndex;this._shadowDiv.style.zIndex = shadowZIndex;},
updateRoundedCorners : function() {
if (this.get_isInitialized()) {
this.setupRounded();this.disposeShadowDiv();this.setShadow();}
},
get_Opacity : function() {
return this._opacity;},
set_Opacity : function(value) {
if (this._opacity != value) {
this._opacity = value;this.setupOpacity();this.raisePropertyChanged('Opacity');}
},
get_Rounded : function() {
return this._rounded;},
set_Rounded : function(value) {
if (value != this._rounded) {
this._rounded = value;this.updateRoundedCorners();this.raisePropertyChanged('Rounded');}
},
get_Radius : function() {
return this._radius;},
set_Radius : function(value) {
if (value != this._radius) {
this._radius = value;this.updateRoundedCorners();this.raisePropertyChanged('Radius');}
},
get_Width : function() {
return this._width;},
set_Width : function(value) {
if (value != this._width) {
this._width = value;if (this._shadowDiv) {
$common.setVisible(this._shadowDiv, value > 0);}
this.setShadow(true);this.raisePropertyChanged('Width');}
},
get_TrackPositionDelay : function() {
return this._trackPositionDelay;},
set_TrackPositionDelay : function(value) {
if (value != this._trackPositionDelay) {
this._trackPositionDelay = value;if (this._trackPosition) {
this.stopTimer();this.startTimer();}
this.raisePropertyChanged('TrackPositionDelay');}
},
get_TrackPosition : function() {
return this._trackPosition;},
set_TrackPosition : function(value) {
if (value != this._trackPosition) {
this._trackPosition = value;if (this.get_element()) {
if (value) {
this.startTimer();} else {
this.stopTimer();}
}
this.raisePropertyChanged('TrackPosition');}
}
}
AjaxControlToolkit.DropShadowBehavior.registerClass('AjaxControlToolkit.DropShadowBehavior', AjaxControlToolkit.BehaviorBase);
//END AjaxControlToolkit.DropShadow.DropShadowBehavior.js
//START AjaxControlToolkit.DynamicPopulate.DynamicPopulateBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.DynamicPopulateBehavior = function(element) {
AjaxControlToolkit.DynamicPopulateBehavior.initializeBase(this, [element]);this._servicePath = null;this._serviceMethod = null;this._contextKey = null;this._cacheDynamicResults = false;this._populateTriggerID = null;this._setUpdatingCssClass = null;this._clearDuringUpdate = true;this._customScript = null;this._clickHandler = null;this._callID = 0;this._currentCallID = -1;this._populated = false;}
AjaxControlToolkit.DynamicPopulateBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.DynamicPopulateBehavior.callBaseMethod(this, 'initialize');$common.prepareHiddenElementForATDeviceUpdate();if (this._populateTriggerID) {
var populateTrigger = $get(this._populateTriggerID);if (populateTrigger) {
this._clickHandler = Function.createDelegate(this, this._onPopulateTriggerClick);$addHandler(populateTrigger, "click", this._clickHandler);}
}
},
dispose : function() {
if (this._populateTriggerID && this._clickHandler) {
var populateTrigger = $get(this._populateTriggerID);if (populateTrigger) {
$removeHandler(populateTrigger, "click", this._clickHandler);}
this._populateTriggerID = null;this._clickHandler = null;}
AjaxControlToolkit.DynamicPopulateBehavior.callBaseMethod(this, 'dispose');},
populate : function(contextKey) {
if (this._populated && this._cacheDynamicResults) {
return;}
if (this._currentCallID == -1) {
var eventArgs = new Sys.CancelEventArgs();this.raisePopulating(eventArgs);if (eventArgs.get_cancel()) {
return;}
this._setUpdating(true);}
if (this._customScript) {
var scriptResult = eval(this._customScript);this._setTargetHtml(scriptResult);this._setUpdating(false);} else {
this._currentCallID = ++this._callID;if (this._servicePath && this._serviceMethod) {
Sys.Net.WebServiceProxy.invoke(this._servicePath, this._serviceMethod, false,
{ contextKey:(contextKey ? contextKey : this._contextKey) },
Function.createDelegate(this, this._onMethodComplete), Function.createDelegate(this, this._onMethodError),
this._currentCallID);$common.updateFormToRefreshATDeviceBuffer();}
}
},
_onMethodComplete : function (result, userContext, methodName) {
if (userContext != this._currentCallID) return;this._setTargetHtml(result);this._setUpdating(false);},
_onMethodError : function(webServiceError, userContext, methodName) {
if (userContext != this._currentCallID) return;if (webServiceError.get_timedOut()) {
this._setTargetHtml(AjaxControlToolkit.Resources.DynamicPopulate_WebServiceTimeout);} else {
this._setTargetHtml(String.format(AjaxControlToolkit.Resources.DynamicPopulate_WebServiceError, webServiceError.get_statusCode()));}
this._setUpdating(false);},
_onPopulateTriggerClick : function() {
this.populate(this._contextKey);},
_setUpdating : function(updating) {
this.setStyle(updating);if (!updating) {
this._currentCallID = -1;this._populated = true;this.raisePopulated(this, Sys.EventArgs.Empty);}
},
_setTargetHtml : function(value) {
var e = this.get_element()
if (e) {
if (e.tagName == "INPUT") {
e.value = value;} else {
e.innerHTML = value;}
}
},
setStyle : function(updating) {
var e = this.get_element();if (this._setUpdatingCssClass) {
if (!updating) {
e.className = this._oldCss;this._oldCss = null;} else {
this._oldCss = e.className;e.className = this._setUpdatingCssClass;}
}
if (updating && this._clearDuringUpdate) {
this._setTargetHtml("");}
},
get_ClearContentsDuringUpdate : function() {
return this._clearDuringUpdate;},
set_ClearContentsDuringUpdate : function(value) {
if (this._clearDuringUpdate != value) {
this._clearDuringUpdate = value;this.raisePropertyChanged('ClearContentsDuringUpdate');}
},
get_ContextKey : function() {
return this._contextKey;},
set_ContextKey : function(value) {
if (this._contextKey != value) {
this._contextKey = value;this.raisePropertyChanged('ContextKey');}
},
get_PopulateTriggerID : function() {
return this._populateTriggerID;},
set_PopulateTriggerID : function(value) {
if (this._populateTriggerID != value) {
this._populateTriggerID = value;this.raisePropertyChanged('PopulateTriggerID');}
},
get_ServicePath : function() {
return this._servicePath;},
set_ServicePath : function(value) {
if (this._servicePath != value) {
this._servicePath = value;this.raisePropertyChanged('ServicePath');}
},
get_ServiceMethod : function() {
return this._serviceMethod;},
set_ServiceMethod : function(value) {
if (this._serviceMethod != value) {
this._serviceMethod = value;this.raisePropertyChanged('ServiceMethod');}
},
get_cacheDynamicResults : function() {
return this._cacheDynamicResults;},
set_cacheDynamicResults : function(value) {
if (this._cacheDynamicResults != value) {
this._cacheDynamicResults = value;this.raisePropertyChanged('cacheDynamicResults');}
},
get_UpdatingCssClass : function() {
return this._setUpdatingCssClass;},
set_UpdatingCssClass : function(value) {
if (this._setUpdatingCssClass != value) {
this._setUpdatingCssClass = value;this.raisePropertyChanged('UpdatingCssClass');}
},
get_CustomScript : function() {
return this._customScript;}, 
set_CustomScript : function(value) {
if (this._customScript != value) {
this._customScript = value;this.raisePropertyChanged('CustomScript');}
},
add_populating : function(handler) {
this.get_events().addHandler('populating', handler);},
remove_populating : function(handler) {
this.get_events().removeHandler('populating', handler);},
raisePopulating : function(eventArgs) {
var handler = this.get_events().getHandler('populating');if (handler) {
handler(this, eventArgs);}
},
add_populated : function(handler) {
this.get_events().addHandler('populated', handler);},
remove_populated : function(handler) {
this.get_events().removeHandler('populated', handler);},
raisePopulated : function(eventArgs) {
var handler = this.get_events().getHandler('populated');if (handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit.DynamicPopulateBehavior.registerClass('AjaxControlToolkit.DynamicPopulateBehavior', AjaxControlToolkit.BehaviorBase);
//END AjaxControlToolkit.DynamicPopulate.DynamicPopulateBehavior.js
//START AjaxControlToolkit.Compat.DragDrop.DragDropScripts.js
/////////////////////////////////////////////////////////////////////////////
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.IDragSource = function() {
}
AjaxControlToolkit.IDragSource.prototype = {
get_dragDataType: function() { throw Error.notImplemented();},
getDragData: function() { throw Error.notImplemented();},
get_dragMode: function() { throw Error.notImplemented();},
onDragStart: function() { throw Error.notImplemented();},
onDrag: function() { throw Error.notImplemented();},
onDragEnd: function() { throw Error.notImplemented();}
}
AjaxControlToolkit.IDragSource.registerInterface('AjaxControlToolkit.IDragSource');/////////////////////////////////////////////////////////////////////////////
AjaxControlToolkit.IDropTarget = function() {
}
AjaxControlToolkit.IDropTarget.prototype = {
get_dropTargetElement: function() { throw Error.notImplemented();},
canDrop: function() { throw Error.notImplemented();},
drop: function() { throw Error.notImplemented();},
onDragEnterTarget: function() { throw Error.notImplemented();},
onDragLeaveTarget: function() { throw Error.notImplemented();},
onDragInTarget: function() { throw Error.notImplemented();}
}
AjaxControlToolkit.IDropTarget.registerInterface('AjaxControlToolkit.IDropTarget');/////////////////////////////////////////////
AjaxControlToolkit.DragMode = function() {
throw Error.invalidOperation();}
AjaxControlToolkit.DragMode.prototype = {
Copy: 0,
Move: 1
}
AjaxControlToolkit.DragMode.registerEnum('AjaxControlToolkit.DragMode');//////////////////////////////////////////////////////////////////
AjaxControlToolkit.DragDropEventArgs = function(dragMode, dragDataType, dragData) {
this._dragMode = dragMode;this._dataType = dragDataType;this._data = dragData;}
AjaxControlToolkit.DragDropEventArgs.prototype = {
get_dragMode: function() {
return this._dragMode || null;},
get_dragDataType: function() {
return this._dataType || null;},
get_dragData: function() {
return this._data || null;}
}
AjaxControlToolkit.DragDropEventArgs.registerClass('AjaxControlToolkit.DragDropEventArgs');AjaxControlToolkit._DragDropManager = function() {
this._instance = null;this._events = null;}
AjaxControlToolkit._DragDropManager.prototype = {
add_dragStart: function(handler) {
this.get_events().addHandler('dragStart', handler);},
remove_dragStart: function(handler) {
this.get_events().removeHandler('dragStart', handler);},
get_events: function() {
if (!this._events) {
this._events = new Sys.EventHandlerList();}
return this._events;},
add_dragStop: function(handler) {
this.get_events().addHandler('dragStop', handler);},
remove_dragStop: function(handler) {
this.get_events().removeHandler('dragStop', handler);},
_getInstance: function() {
if (!this._instance) {
if (Sys.Browser.agent === Sys.Browser.InternetExplorer) {
this._instance = new AjaxControlToolkit.IEDragDropManager();}
else {
this._instance = new AjaxControlToolkit.GenericDragDropManager();}
this._instance.initialize();this._instance.add_dragStart(Function.createDelegate(this, this._raiseDragStart));this._instance.add_dragStop(Function.createDelegate(this, this._raiseDragStop));}
return this._instance;},
startDragDrop: function(dragSource, dragVisual, context) {
this._getInstance().startDragDrop(dragSource, dragVisual, context);},
registerDropTarget: function(target) {
this._getInstance().registerDropTarget(target);},
unregisterDropTarget: function(target) {
this._getInstance().unregisterDropTarget(target);},
dispose: function() {
delete this._events;Sys.Application.unregisterDisposableObject(this);Sys.Application.removeComponent(this);},
_raiseDragStart: function(sender, eventArgs) {
var handler = this.get_events().getHandler('dragStart');if(handler) {
handler(this, eventArgs);}
},
_raiseDragStop: function(sender, eventArgs) {
var handler = this.get_events().getHandler('dragStop');if(handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit._DragDropManager.registerClass('AjaxControlToolkit._DragDropManager');AjaxControlToolkit.DragDropManager = new AjaxControlToolkit._DragDropManager();AjaxControlToolkit.IEDragDropManager = function() {
AjaxControlToolkit.IEDragDropManager.initializeBase(this);this._dropTargets = null;this._radius = 10;this._activeDragVisual = null;this._activeContext = null;this._activeDragSource = null;this._underlyingTarget = null;this._oldOffset = null;this._potentialTarget = null;this._isDragging = false;this._mouseUpHandler = null;this._documentMouseMoveHandler = null;this._documentDragOverHandler = null;this._dragStartHandler = null;this._mouseMoveHandler = null;this._dragEnterHandler = null;this._dragLeaveHandler = null;this._dragOverHandler = null;this._dropHandler = null;}
AjaxControlToolkit.IEDragDropManager.prototype = {
add_dragStart : function(handler) {
this.get_events().addHandler("dragStart", handler);},
remove_dragStart : function(handler) {
this.get_events().removeHandler("dragStart", handler);},
add_dragStop : function(handler) {
this.get_events().addHandler("dragStop", handler);},
remove_dragStop : function(handler) {
this.get_events().removeHandler("dragStop", handler);},
initialize : function() {
AjaxControlToolkit.IEDragDropManager.callBaseMethod(this, 'initialize');this._mouseUpHandler = Function.createDelegate(this, this._onMouseUp);this._documentMouseMoveHandler = Function.createDelegate(this, this._onDocumentMouseMove);this._documentDragOverHandler = Function.createDelegate(this, this._onDocumentDragOver);this._dragStartHandler = Function.createDelegate(this, this._onDragStart);this._mouseMoveHandler = Function.createDelegate(this, this._onMouseMove);this._dragEnterHandler = Function.createDelegate(this, this._onDragEnter);this._dragLeaveHandler = Function.createDelegate(this, this._onDragLeave);this._dragOverHandler = Function.createDelegate(this, this._onDragOver);this._dropHandler = Function.createDelegate(this, this._onDrop);},
dispose : function() {
if(this._dropTargets) {
for (var i = 0;i < this._dropTargets;i++) {
this.unregisterDropTarget(this._dropTargets[i]);}
this._dropTargets = null;}
AjaxControlToolkit.IEDragDropManager.callBaseMethod(this, 'dispose');},
startDragDrop : function(dragSource, dragVisual, context) {
var ev = window._event;if (this._isDragging) {
return;}
this._underlyingTarget = null;this._activeDragSource = dragSource;this._activeDragVisual = dragVisual;this._activeContext = context;var mousePosition = { x: ev.clientX, y: ev.clientY };dragVisual.originalPosition = dragVisual.style.position;dragVisual.style.position = "absolute";document._lastPosition = mousePosition;dragVisual.startingPoint = mousePosition;var scrollOffset = this.getScrollOffset(dragVisual,  true);dragVisual.startingPoint = this.addPoints(dragVisual.startingPoint, scrollOffset);if (dragVisual.style.position == "absolute") {
dragVisual.startingPoint = this.subtractPoints(dragVisual.startingPoint, $common.getLocation(dragVisual));}
else {
var left = parseInt(dragVisual.style.left);var top = parseInt(dragVisual.style.top);if (isNaN(left)) left = "0";if (isNaN(top)) top = "0";dragVisual.startingPoint = this.subtractPoints(dragVisual.startingPoint, { x: left, y: top });}
this._prepareForDomChanges();dragSource.onDragStart();var eventArgs = new AjaxControlToolkit.DragDropEventArgs(
dragSource.get_dragMode(),
dragSource.get_dragDataType(),
dragSource.getDragData(context));var handler = this.get_events().getHandler('dragStart');if(handler) handler(this,eventArgs);this._recoverFromDomChanges();this._wireEvents();this._drag( true);},
_stopDragDrop : function(cancelled) {
var ev = window._event;if (this._activeDragSource != null) {
this._unwireEvents();if (!cancelled) {
cancelled = (this._underlyingTarget == null);}
if (!cancelled && this._underlyingTarget != null) {
this._underlyingTarget.drop(this._activeDragSource.get_dragMode(), this._activeDragSource.get_dragDataType(),
this._activeDragSource.getDragData(this._activeContext));}
this._activeDragSource.onDragEnd(cancelled);var handler = this.get_events().getHandler('dragStop');if(handler) handler(this,Sys.EventArgs.Empty);this._activeDragVisual.style.position = this._activeDragVisual.originalPosition;this._activeDragSource = null;this._activeContext = null;this._activeDragVisual = null;this._isDragging = false;this._potentialTarget = null;ev.preventDefault();}
},
_drag : function(isInitialDrag) {
var ev = window._event;var mousePosition = { x: ev.clientX, y: ev.clientY };document._lastPosition = mousePosition;var scrollOffset = this.getScrollOffset(this._activeDragVisual,  true);var position = this.addPoints(this.subtractPoints(mousePosition, this._activeDragVisual.startingPoint), scrollOffset);if (!isInitialDrag && parseInt(this._activeDragVisual.style.left) == position.x && parseInt(this._activeDragVisual.style.top) == position.y) {
return;}
$common.setLocation(this._activeDragVisual, position);this._prepareForDomChanges();this._activeDragSource.onDrag();this._recoverFromDomChanges();this._potentialTarget = this._findPotentialTarget(this._activeDragSource, this._activeDragVisual);var movedToOtherTarget = (this._potentialTarget != this._underlyingTarget || this._potentialTarget == null);if (movedToOtherTarget && this._underlyingTarget != null) {
this._leaveTarget(this._activeDragSource, this._underlyingTarget);}
if (this._potentialTarget != null) {
if (movedToOtherTarget) {
this._underlyingTarget = this._potentialTarget;this._enterTarget(this._activeDragSource, this._underlyingTarget);}
else {
this._moveInTarget(this._activeDragSource, this._underlyingTarget);}
}
else {
this._underlyingTarget = null;}
},
_wireEvents : function() {
$addHandler(document, "mouseup", this._mouseUpHandler);$addHandler(document, "mousemove", this._documentMouseMoveHandler);$addHandler(document.body, "dragover", this._documentDragOverHandler);$addHandler(this._activeDragVisual, "dragstart", this._dragStartHandler);$addHandler(this._activeDragVisual, "dragend", this._mouseUpHandler);$addHandler(this._activeDragVisual, "drag", this._mouseMoveHandler);},
_unwireEvents : function() {
$removeHandler(this._activeDragVisual, "drag", this._mouseMoveHandler);$removeHandler(this._activeDragVisual, "dragend", this._mouseUpHandler);$removeHandler(this._activeDragVisual, "dragstart", this._dragStartHandler);$removeHandler(document.body, "dragover", this._documentDragOverHandler);$removeHandler(document, "mousemove", this._documentMouseMoveHandler);$removeHandler(document, "mouseup", this._mouseUpHandler);},
registerDropTarget : function(dropTarget) {
if (this._dropTargets == null) {
this._dropTargets = [];}
Array.add(this._dropTargets, dropTarget);this._wireDropTargetEvents(dropTarget);},
unregisterDropTarget : function(dropTarget) {
this._unwireDropTargetEvents(dropTarget);if (this._dropTargets) {
Array.remove(this._dropTargets, dropTarget);}
},
_wireDropTargetEvents : function(dropTarget) {
var associatedElement = dropTarget.get_dropTargetElement();associatedElement._dropTarget = dropTarget;$addHandler(associatedElement, "dragenter", this._dragEnterHandler);$addHandler(associatedElement, "dragleave", this._dragLeaveHandler);$addHandler(associatedElement, "dragover", this._dragOverHandler);$addHandler(associatedElement, "drop", this._dropHandler);},
_unwireDropTargetEvents : function(dropTarget) {
var associatedElement = dropTarget.get_dropTargetElement();if(associatedElement._dropTarget)
{
associatedElement._dropTarget = null;$removeHandler(associatedElement, "dragenter", this._dragEnterHandler);$removeHandler(associatedElement, "dragleave", this._dragLeaveHandler);$removeHandler(associatedElement, "dragover", this._dragOverHandler);$removeHandler(associatedElement, "drop", this._dropHandler);}
},
_onDragStart : function(ev) {
window._event = ev;document.selection.empty();var dt = ev.dataTransfer;if(!dt && ev.rawEvent) dt = ev.rawEvent.dataTransfer;var dataType = this._activeDragSource.get_dragDataType().toLowerCase();var data = this._activeDragSource.getDragData(this._activeContext);if (data) {
if (dataType != "text" && dataType != "url") {
dataType = "text";if (data.innerHTML != null) {
data = data.innerHTML;}
}
dt.effectAllowed = "move";dt.setData(dataType, data.toString());}
},
_onMouseUp : function(ev) {
window._event = ev;this._stopDragDrop(false);},
_onDocumentMouseMove : function(ev) {
window._event = ev;this._dragDrop();},
_onDocumentDragOver : function(ev) {
window._event = ev;if(this._potentialTarget) ev.preventDefault();},
_onMouseMove : function(ev) {
window._event = ev;this._drag();},
_onDragEnter : function(ev) {
window._event = ev;if (this._isDragging) {
ev.preventDefault();}
else {
var dataObjects = AjaxControlToolkit.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(ev.target));for (var i = 0;i < dataObjects.length;i++) {
this._dropTarget.onDragEnterTarget(AjaxControlToolkit.DragMode.Copy, dataObjects[i].type, dataObjects[i].value);}
}
},
_onDragLeave : function(ev) {
window._event = ev;if (this._isDragging) {
ev.preventDefault();}
else {
var dataObjects = AjaxControlToolkit.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(ev.target));for (var i = 0;i < dataObjects.length;i++) {
this._dropTarget.onDragLeaveTarget(AjaxControlToolkit.DragMode.Copy, dataObjects[i].type, dataObjects[i].value);}
}
},
_onDragOver : function(ev) {
window._event = ev;if (this._isDragging) {
ev.preventDefault();}
else {
var dataObjects = AjaxControlToolkit.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(ev.target));for (var i = 0;i < dataObjects.length;i++) {
this._dropTarget.onDragInTarget(AjaxControlToolkit.DragMode.Copy, dataObjects[i].type, dataObjects[i].value);}
}
},
_onDrop : function(ev) {
window._event = ev;if (!this._isDragging) {
var dataObjects = AjaxControlToolkit.IEDragDropManager._getDataObjectsForDropTarget(this._getDropTarget(ev.target));for (var i = 0;i < dataObjects.length;i++) {
this._dropTarget.drop(AjaxControlToolkit.DragMode.Copy, dataObjects[i].type, dataObjects[i].value);}
}
ev.preventDefault();},
_getDropTarget : function(element) {
while (element) {
if (element._dropTarget != null) {
return element._dropTarget;}
element = element.parentNode;}
return null;},
_dragDrop : function() {
if (this._isDragging) {
return;}
this._isDragging = true;this._activeDragVisual.dragDrop();document.selection.empty();},
_moveInTarget : function(dragSource, dropTarget) {
this._prepareForDomChanges();dropTarget.onDragInTarget(dragSource.get_dragMode(), dragSource.get_dragDataType(), dragSource.getDragData(this._activeContext));this._recoverFromDomChanges();},
_enterTarget : function(dragSource, dropTarget) {
this._prepareForDomChanges();dropTarget.onDragEnterTarget(dragSource.get_dragMode(), dragSource.get_dragDataType(), dragSource.getDragData(this._activeContext));this._recoverFromDomChanges();},
_leaveTarget : function(dragSource, dropTarget) {
this._prepareForDomChanges();dropTarget.onDragLeaveTarget(dragSource.get_dragMode(), dragSource.get_dragDataType(), dragSource.getDragData(this._activeContext));this._recoverFromDomChanges();},
_findPotentialTarget : function(dragSource, dragVisual) {
var ev = window._event;if (this._dropTargets == null) {
return null;}
var type = dragSource.get_dragDataType();var mode = dragSource.get_dragMode();var data = dragSource.getDragData(this._activeContext);var scrollOffset = this.getScrollOffset(document.body,  true);var x = ev.clientX + scrollOffset.x;var y = ev.clientY + scrollOffset.y;var cursorRect = { x: x - this._radius, y: y - this._radius, width: this._radius * 2, height: this._radius * 2 };var targetRect;for (var i = 0;i < this._dropTargets.length;i++) {
targetRect = $common.getBounds(this._dropTargets[i].get_dropTargetElement());if ($common.overlaps(cursorRect, targetRect) && this._dropTargets[i].canDrop(mode, type, data)) {
return this._dropTargets[i];}
}
return null;},
_prepareForDomChanges : function() {
this._oldOffset = $common.getLocation(this._activeDragVisual);},
_recoverFromDomChanges : function() {
var newOffset = $common.getLocation(this._activeDragVisual);if (this._oldOffset.x != newOffset.x || this._oldOffset.y != newOffset.y) {
this._activeDragVisual.startingPoint = this.subtractPoints(this._activeDragVisual.startingPoint, this.subtractPoints(this._oldOffset, newOffset));scrollOffset = this.getScrollOffset(this._activeDragVisual,  true);var position = this.addPoints(this.subtractPoints(document._lastPosition, this._activeDragVisual.startingPoint), scrollOffset);$common.setLocation(this._activeDragVisual, position);}
},
addPoints : function(p1, p2) {
return { x: p1.x + p2.x, y: p1.y + p2.y };},
subtractPoints : function(p1, p2) {
return { x: p1.x - p2.x, y: p1.y - p2.y };},
getScrollOffset : function(element, recursive) {
var left = element.scrollLeft;var top = element.scrollTop;if (recursive) {
var parent = element.parentNode;while (parent != null && parent.scrollLeft != null) {
left += parent.scrollLeft;top += parent.scrollTop;if (parent == document.body && (left != 0 && top != 0))
break;parent = parent.parentNode;}
}
return { x: left, y: top };},
getBrowserRectangle : function() {
var width = window.innerWidth;var height = window.innerHeight;if (width == null) {
width = document.body.clientWidth;}
if (height == null) {
height = document.body.clientHeight;}
return { x: 0, y: 0, width: width, height: height };},
getNextSibling : function(item) {
for (item = item.nextSibling;item != null;item = item.nextSibling) {
if (item.innerHTML != null) {
return item;}
}
return null;},
hasParent : function(element) {
return (element.parentNode != null && element.parentNode.tagName != null);}
}
AjaxControlToolkit.IEDragDropManager.registerClass('AjaxControlToolkit.IEDragDropManager', Sys.Component);AjaxControlToolkit.IEDragDropManager._getDataObjectsForDropTarget = function(dropTarget) {
if (dropTarget == null) {
return [];}
var ev = window._event;var dataObjects = [];var dataTypes = [ "URL", "Text" ];var data;for (var i = 0;i < dataTypes.length;i++) {
var dt = ev.dataTransfer;if(!dt && ev.rawEvent) dt = ev.rawEvent.dataTransfer;data = dt.getData(dataTypes[i]);if (dropTarget.canDrop(AjaxControlToolkit.DragMode.Copy, dataTypes[i], data)) {
if (data) {
Array.add(dataObjects, { type : dataTypes[i], value : data });}
}
}
return dataObjects;}
AjaxControlToolkit.GenericDragDropManager = function() {
AjaxControlToolkit.GenericDragDropManager.initializeBase(this);this._dropTargets = null;this._scrollEdgeConst = 40;this._scrollByConst = 10;this._scroller = null;this._scrollDeltaX = 0;this._scrollDeltaY = 0;this._activeDragVisual = null;this._activeContext = null;this._activeDragSource = null;this._oldOffset = null;this._potentialTarget = null;this._mouseUpHandler = null;this._mouseMoveHandler = null;this._keyPressHandler = null;this._scrollerTickHandler = null;}
AjaxControlToolkit.GenericDragDropManager.prototype = {
initialize : function() {
AjaxControlToolkit.GenericDragDropManager.callBaseMethod(this, "initialize");this._mouseUpHandler = Function.createDelegate(this, this._onMouseUp);this._mouseMoveHandler = Function.createDelegate(this, this._onMouseMove);this._keyPressHandler = Function.createDelegate(this, this._onKeyPress);this._scrollerTickHandler = Function.createDelegate(this, this._onScrollerTick);if (Sys.Browser.agent === Sys.Browser.Safari) {
AjaxControlToolkit.GenericDragDropManager.__loadSafariCompatLayer(this);}
this._scroller = new Sys.Timer();this._scroller.set_interval(10);this._scroller.add_tick(this._scrollerTickHandler);},
startDragDrop : function(dragSource, dragVisual, context) {
this._activeDragSource = dragSource;this._activeDragVisual = dragVisual;this._activeContext = context;AjaxControlToolkit.GenericDragDropManager.callBaseMethod(this, "startDragDrop", [dragSource, dragVisual, context]);},
_stopDragDrop : function(cancelled) {
this._scroller.set_enabled(false);AjaxControlToolkit.GenericDragDropManager.callBaseMethod(this, "_stopDragDrop", [cancelled]);},
_drag : function(isInitialDrag) {
AjaxControlToolkit.GenericDragDropManager.callBaseMethod(this, "_drag", [isInitialDrag]);this._autoScroll();},
_wireEvents : function() {
$addHandler(document, "mouseup", this._mouseUpHandler);$addHandler(document, "mousemove", this._mouseMoveHandler);$addHandler(document, "keypress", this._keyPressHandler);},
_unwireEvents : function() {
$removeHandler(document, "keypress", this._keyPressHandler);$removeHandler(document, "mousemove", this._mouseMoveHandler);$removeHandler(document, "mouseup", this._mouseUpHandler);},
_wireDropTargetEvents : function(dropTarget) {
},
_unwireDropTargetEvents : function(dropTarget) {
},
_onMouseUp : function(e) {
window._event = e;this._stopDragDrop(false);},
_onMouseMove : function(e) {
window._event = e;this._drag();},
_onKeyPress : function(e) {
window._event = e;var k = e.keyCode ? e.keyCode : e.rawEvent.keyCode;if (k == 27) {
this._stopDragDrop( true);}
},
_autoScroll : function() {
var ev = window._event;var browserRect = this.getBrowserRectangle();if (browserRect.width > 0) {
this._scrollDeltaX = this._scrollDeltaY = 0;if (ev.clientX < browserRect.x + this._scrollEdgeConst) this._scrollDeltaX = -this._scrollByConst;else if (ev.clientX > browserRect.width - this._scrollEdgeConst) this._scrollDeltaX = this._scrollByConst;if (ev.clientY < browserRect.y + this._scrollEdgeConst) this._scrollDeltaY = -this._scrollByConst;else if (ev.clientY > browserRect.height - this._scrollEdgeConst) this._scrollDeltaY = this._scrollByConst;if (this._scrollDeltaX != 0 || this._scrollDeltaY != 0) {
this._scroller.set_enabled(true);}
else {
this._scroller.set_enabled(false);}
}
},
_onScrollerTick : function() {
var oldLeft = document.body.scrollLeft;var oldTop = document.body.scrollTop;window.scrollBy(this._scrollDeltaX, this._scrollDeltaY);var newLeft = document.body.scrollLeft;var newTop = document.body.scrollTop;var dragVisual = this._activeDragVisual;var position = { x: parseInt(dragVisual.style.left) + (newLeft - oldLeft), y: parseInt(dragVisual.style.top) + (newTop - oldTop) };$common.setLocation(dragVisual, position);}
}
AjaxControlToolkit.GenericDragDropManager.registerClass('AjaxControlToolkit.GenericDragDropManager', AjaxControlToolkit.IEDragDropManager);if (Sys.Browser.agent === Sys.Browser.Safari) {
AjaxControlToolkit.GenericDragDropManager.__loadSafariCompatLayer = function(ddm) {
ddm._getScrollOffset = ddm.getScrollOffset;ddm.getScrollOffset = function(element, recursive) {
return { x: 0, y: 0 };}
ddm._getBrowserRectangle = ddm.getBrowserRectangle;ddm.getBrowserRectangle = function() {
var browserRect = ddm._getBrowserRectangle();var offset = ddm._getScrollOffset(document.body, true);return { x: browserRect.x + offset.x, y: browserRect.y + offset.y,
width: browserRect.width + offset.x, height: browserRect.height + offset.y };}
}
}

//END AjaxControlToolkit.Compat.DragDrop.DragDropScripts.js
//START AjaxControlToolkit.DragPanel.FloatingBehavior.js
AjaxControlToolkit.FloatingBehavior = function(element) {
AjaxControlToolkit.FloatingBehavior.initializeBase(this,[element]);var _handle;var _location;var _dragStartLocation;var _profileProperty;var _profileComponent;var _mouseDownHandler = Function.createDelegate(this, mouseDownHandler);this.add_move = function(handler) {
this.get_events().addHandler('move', handler);}
this.remove_move = function(handler) {
this.get_events().removeHandler('move', handler);}
this.get_handle = function() {
return _handle;}
this.set_handle = function(value) {
if (_handle != null) {
$removeHandler(_handle, "mousedown", _mouseDownHandler);}
_handle = value;$addHandler(_handle, "mousedown", _mouseDownHandler);}
this.get_profileProperty = function() {
return _profileProperty;}
this.set_profileProperty = function(value) {
_profileProperty = value;}
this.get_profileComponent = function() {
return _profileComponent;}
this.set_profileComponent = function(value) {
_profileComponent = value;}
this.get_location = function() {
return _location;}
this.set_location = function(value) {
if (_location != value) {
_location = value;if (this.get_isInitialized()) { 
$common.setLocation(this.get_element(), _location);}
this.raisePropertyChanged('location');}
}
this.initialize = function() {
AjaxControlToolkit.FloatingBehavior.callBaseMethod(this, 'initialize');AjaxControlToolkit.DragDropManager.registerDropTarget(this);var el = this.get_element();if (!_location) { 
_location = $common.getLocation(el);}
el.style.position = "fixed";$common.setLocation(el, _location);}
this.dispose = function() {
AjaxControlToolkit.DragDropManager.unregisterDropTarget(this);if (_handle && _mouseDownHandler) {
$removeHandler(_handle, "mousedown", _mouseDownHandler);}
_mouseDownHandler = null;AjaxControlToolkit.FloatingBehavior.callBaseMethod(this, 'dispose');}
this.checkCanDrag = function(element) {
var undraggableTagNames = ["input", "button", "select", "textarea", "label"];var tagName = element.tagName;if ((tagName.toLowerCase() == "a") && (element.href != null) && (element.href.length > 0)) {
return false;}
if (Array.indexOf(undraggableTagNames, tagName.toLowerCase()) > -1) {
return false;}
return true;}
function mouseDownHandler(ev) {
window._event = ev;var el = this.get_element();if (this.checkCanDrag(ev.target)) {
_dragStartLocation = $common.getLocation(el);ev.preventDefault();this.startDragDrop(el);}
}
this.get_dragDataType = function() {
return "_floatingObject";}
this.getDragData = function(context) {
return null;}
this.get_dragMode = function() {
return AjaxControlToolkit.DragMode.Move;}
this.onDragStart = function() { }
this.onDrag = function() { }
this.onDragEnd = function(canceled) {
if (!canceled) {
var handler = this.get_events().getHandler('move');if(handler) {
var cancelArgs = new Sys.CancelEventArgs();handler(this, cancelArgs);canceled = cancelArgs.get_cancel();} 
}
var el = this.get_element();if (canceled) {
$common.setLocation(el, _dragStartLocation);} else {
_location = $common.getLocation(el);this.raisePropertyChanged('location');}
}
this.startDragDrop = function(dragVisual) {
AjaxControlToolkit.DragDropManager.startDragDrop(this, dragVisual, null);}
this.get_dropTargetElement = function() {
return document.body;}
this.canDrop = function(dragMode, dataType, data) {
return (dataType == "_floatingObject");}
this.drop = function(dragMode, dataType, data) {}
this.onDragEnterTarget = function(dragMode, dataType, data) {}
this.onDragLeaveTarget = function(dragMode, dataType, data) {}
this.onDragInTarget = function(dragMode, dataType, data) {}
}
AjaxControlToolkit.FloatingBehavior.registerClass('AjaxControlToolkit.FloatingBehavior', AjaxControlToolkit.BehaviorBase, AjaxControlToolkit.IDragSource, AjaxControlToolkit.IDropTarget, Sys.IDisposable);
//END AjaxControlToolkit.DragPanel.FloatingBehavior.js
//START AjaxControlToolkit.ModalPopup.ModalPopupBehavior.js
Type.registerNamespace('AjaxControlToolkit');AjaxControlToolkit.ModalPopupRepositionMode = function() {
throw Error.invalidOperation();}
AjaxControlToolkit.ModalPopupRepositionMode.prototype = {
None : 0,
RepositionOnWindowResize : 1,
RepositionOnWindowScroll : 2,
RepositionOnWindowResizeAndScroll : 3
}
AjaxControlToolkit.ModalPopupRepositionMode.registerEnum('AjaxControlToolkit.ModalPopupRepositionMode');AjaxControlToolkit.ModalPopupBehavior = function(element) {
AjaxControlToolkit.ModalPopupBehavior.initializeBase(this, [element]);this._PopupControlID = null;this._PopupDragHandleControlID = null;this._BackgroundCssClass = null;this._DropShadow = false;this._Drag = false;this._OkControlID = null;this._CancelControlID = null;this._OnOkScript = null;this._OnCancelScript = null;this._xCoordinate = -1;this._yCoordinate = -1;this._repositionMode = AjaxControlToolkit.ModalPopupRepositionMode.RepositionOnWindowResizeAndScroll;this._backgroundElement = null;this._foregroundElement = null;this._relativeOrAbsoluteParentElement = null;this._popupElement = null;this._dragHandleElement = null;this._showHandler = null;this._okHandler = null;this._cancelHandler = null;this._scrollHandler = null;this._resizeHandler = null;this._windowHandlersAttached = false;this._dropShadowBehavior = null;this._dragBehavior = null;this._isIE6 = false;this._saveTabIndexes = new Array();this._saveDesableSelect = new Array();this._tagWithTabIndex = new Array('A','AREA','BUTTON','INPUT','OBJECT','SELECT','TEXTAREA','IFRAME');}
AjaxControlToolkit.ModalPopupBehavior.prototype = {
initialize : function() {
AjaxControlToolkit.ModalPopupBehavior.callBaseMethod(this, 'initialize');this._isIE6 = (Sys.Browser.agent == Sys.Browser.InternetExplorer && Sys.Browser.version < 7);if(this._PopupDragHandleControlID)
this._dragHandleElement = $get(this._PopupDragHandleControlID);this._popupElement = $get(this._PopupControlID);if(this._DropShadow)
{
this._foregroundElement = document.createElement('div');this._foregroundElement.id = this.get_id() + '_foregroundElement';this._popupElement.parentNode.appendChild(this._foregroundElement);this._foregroundElement.appendChild(this._popupElement);}
else
{
this._foregroundElement = this._popupElement;}
this._backgroundElement = document.createElement('div');this._backgroundElement.id = this.get_id() + '_backgroundElement';this._backgroundElement.style.display = 'none';this._backgroundElement.style.position = 'absolute';this._backgroundElement.style.left = '0px';this._backgroundElement.style.top = '0px';this._backgroundElement.style.zIndex = 10000;if (this._BackgroundCssClass) {
this._backgroundElement.className = this._BackgroundCssClass;}
this._foregroundElement.parentNode.appendChild(this._backgroundElement);this._foregroundElement.style.display = 'none';this._foregroundElement.style.position = 'absolute';this._foregroundElement.style.zIndex = $common.getCurrentStyle(this._backgroundElement, 'zIndex', this._backgroundElement.style.zIndex) + 1;this._showHandler = Function.createDelegate(this, this._onShow);$addHandler(this.get_element(), 'click', this._showHandler);if (this._OkControlID) {
this._okHandler = Function.createDelegate(this, this._onOk);$addHandler($get(this._OkControlID), 'click', this._okHandler);}
if (this._CancelControlID) {
this._cancelHandler = Function.createDelegate(this, this._onCancel);$addHandler($get(this._CancelControlID), 'click', this._cancelHandler);}
this._scrollHandler = Function.createDelegate(this, this._onLayout);this._resizeHandler = Function.createDelegate(this, this._onLayout);this.registerPartialUpdateEvents();},
dispose : function() {
this._hideImplementation();if (this._foregroundElement && this._foregroundElement.parentNode) {
this._foregroundElement.parentNode.removeChild(this._backgroundElement);if(this._DropShadow) {
this._foregroundElement.parentNode.appendChild(this._popupElement);this._foregroundElement.parentNode.removeChild(this._foregroundElement);}
}
this._scrollHandler = null;this._resizeHandler = null;if (this._cancelHandler && $get(this._CancelControlID)) {
$removeHandler($get(this._CancelControlID), 'click', this._cancelHandler);this._cancelHandler = null;}
if (this._okHandler && $get(this._OkControlID)) {
$removeHandler($get(this._OkControlID), 'click', this._okHandler);this._okHandler = null;}
if (this._showHandler) {
$removeHandler(this.get_element(), 'click', this._showHandler);this._showHandler = null;}
AjaxControlToolkit.ModalPopupBehavior.callBaseMethod(this, 'dispose');},
_attachPopup : function() {
if (this._DropShadow && !this._dropShadowBehavior) {
this._dropShadowBehavior = $create(AjaxControlToolkit.DropShadowBehavior, {}, null, null, this._popupElement);}
if (this._dragHandleElement && !this._dragBehavior) {
this._dragBehavior = $create(AjaxControlToolkit.FloatingBehavior, {"handle" : this._dragHandleElement}, null, null, this._foregroundElement);} 
$addHandler(window, 'resize', this._resizeHandler);$addHandler(window, 'scroll', this._scrollHandler);this._windowHandlersAttached = true;},
_detachPopup : function() {
if (this._windowHandlersAttached) {
if (this._scrollHandler) {
$removeHandler(window, 'scroll', this._scrollHandler);}
if (this._resizeHandler) {
$removeHandler(window, 'resize', this._resizeHandler);}
this._windowHandlersAttached = false;}
if (this._dragBehavior) {
this._dragBehavior.dispose();this._dragBehavior = null;} 
if (this._dropShadowBehavior) {
this._dropShadowBehavior.dispose();this._dropShadowBehavior = null;}
},
_onShow : function(e) {
if (!this.get_element().disabled) {
this.show();e.preventDefault();return false;}
},
_onOk : function(e) {
var element = $get(this._OkControlID);if (element && !element.disabled) {
if (this.hide() && this._OnOkScript) {
window.setTimeout(this._OnOkScript, 0);}
e.preventDefault();return false;}
},
_onCancel : function(e) {
var element = $get(this._CancelControlID);if (element && !element.disabled) {
if (this.hide() && this._OnCancelScript) {
window.setTimeout(this._OnCancelScript, 0);}
e.preventDefault();return false;}
},
_onLayout : function(e) {
var positioning = this.get_repositionMode();if (((positioning === AjaxControlToolkit.ModalPopupRepositionMode.RepositionOnWindowScroll) ||
(positioning === AjaxControlToolkit.ModalPopupRepositionMode.RepositionOnWindowResizeAndScroll)) && (e.type === 'scroll')) {
this._layout();} else if (((positioning === AjaxControlToolkit.ModalPopupRepositionMode.RepositionOnWindowResize) ||
(positioning === AjaxControlToolkit.ModalPopupRepositionMode.RepositionOnWindowResizeAndScroll)) && (e.type === 'resize')) {
this._layout();} else {
this._layoutBackgroundElement();}
},
show : function() {
var eventArgs = new Sys.CancelEventArgs();this.raiseShowing(eventArgs);if (eventArgs.get_cancel()) {
return;}
this.populate();this._attachPopup();this._backgroundElement.style.display = '';this._foregroundElement.style.display = '';this._popupElement.style.display = '';if (this._isIE6) {
this._foregroundElement.style.position = 'absolute';this._backgroundElement.style.position = 'absolute';var tempRelativeOrAbsoluteParent = this._foregroundElement.parentNode;while (tempRelativeOrAbsoluteParent && (tempRelativeOrAbsoluteParent != document.documentElement)) {
if((tempRelativeOrAbsoluteParent.style.position != 'relative') && (tempRelativeOrAbsoluteParent.style.position != 'absolute')) {
tempRelativeOrAbsoluteParent = tempRelativeOrAbsoluteParent.parentNode;} else {
this._relativeOrAbsoluteParentElement = tempRelativeOrAbsoluteParent;break;}
} 
} 
this.disableTab();this._layout();this._layout();this.raiseShown(Sys.EventArgs.Empty);},
disableTab : function() {
var i = 0;var tagElements;var tagElementsInPopUp = new Array();Array.clear(this._saveTabIndexes);for (var j = 0;j < this._tagWithTabIndex.length;j++) {
tagElements = this._foregroundElement.getElementsByTagName(this._tagWithTabIndex[j]);for (var k = 0 ;k < tagElements.length;k++) {
tagElementsInPopUp[i] = tagElements[k];i++;}
}
i = 0;for (var j = 0;j < this._tagWithTabIndex.length;j++) {
tagElements = document.getElementsByTagName(this._tagWithTabIndex[j]);for (var k = 0 ;k < tagElements.length;k++) {
if (Array.indexOf(tagElementsInPopUp, tagElements[k]) == -1) {
this._saveTabIndexes[i] = {tag: tagElements[k], index: tagElements[k].tabIndex};tagElements[k].tabIndex="-1";i++;}
}
}
i = 0;if ((Sys.Browser.agent === Sys.Browser.InternetExplorer) && (Sys.Browser.version < 7)) {
var tagSelectInPopUp = new Array();for (var j = 0;j < this._tagWithTabIndex.length;j++) {
tagElements = this._foregroundElement.getElementsByTagName('SELECT');for (var k = 0 ;k < tagElements.length;k++) {
tagSelectInPopUp[i] = tagElements[k];i++;}
}
i = 0;Array.clear(this._saveDesableSelect);tagElements = document.getElementsByTagName('SELECT');for (var k = 0 ;k < tagElements.length;k++) {
if (Array.indexOf(tagSelectInPopUp, tagElements[k]) == -1) {
this._saveDesableSelect[i] = {tag: tagElements[k], visib: $common.getCurrentStyle(tagElements[k], 'visibility')} ;tagElements[k].style.visibility = 'hidden';i++;}
}
}
},
restoreTab : function() {
for (var i = 0;i < this._saveTabIndexes.length;i++) {
this._saveTabIndexes[i].tag.tabIndex = this._saveTabIndexes[i].index;}
Array.clear(this._saveTabIndexes);if ((Sys.Browser.agent === Sys.Browser.InternetExplorer) && (Sys.Browser.version < 7)) {
for (var k = 0 ;k < this._saveDesableSelect.length;k++) {
this._saveDesableSelect[k].tag.style.visibility = this._saveDesableSelect[k].visib;}
Array.clear(this._saveDesableSelect);}
},
hide : function() {
var eventArgs = new Sys.CancelEventArgs();this.raiseHiding(eventArgs);if (eventArgs.get_cancel()) {
return false;}
this._hideImplementation();this.raiseHidden(Sys.EventArgs.Empty);return true;},
_hideImplementation : function() {
this._backgroundElement.style.display = 'none';this._foregroundElement.style.display = 'none';this.restoreTab();this._detachPopup();},
_layout : function() {
var scrollLeft = (document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft);var scrollTop = (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);var clientBounds = $common.getClientBounds();var clientWidth = clientBounds.width;var clientHeight = clientBounds.height;this._layoutBackgroundElement();var xCoord = 0;var yCoord = 0;if(this._xCoordinate < 0) {
var foregroundelementwidth = this._foregroundElement.offsetWidth? this._foregroundElement.offsetWidth: this._foregroundElement.scrollWidth;xCoord = ((clientWidth-foregroundelementwidth)/2);if (this._foregroundElement.style.position == 'absolute') {
xCoord += scrollLeft;}
this._foregroundElement.style.left = xCoord + 'px';} else {
if(this._isIE6) {
this._foregroundElement.style.left = (this._xCoordinate + scrollLeft) + 'px';xCoord = this._xCoordinate + scrollLeft;}
else {
this._foregroundElement.style.left = this._xCoordinate + 'px';xCoord = this._xCoordinate;}
}
if(this._yCoordinate < 0) {
var foregroundelementheight = this._foregroundElement.offsetHeight? this._foregroundElement.offsetHeight: this._foregroundElement.scrollHeight;yCoord = ((clientHeight-foregroundelementheight)/2);if (this._foregroundElement.style.position == 'absolute') {
yCoord += scrollTop;}
this._foregroundElement.style.top = yCoord + 'px';} else {
if(this._isIE6) {
this._foregroundElement.style.top = (this._yCoordinate + scrollTop) + 'px';yCoord = this._yCoordinate + scrollTop;}
else {
this._foregroundElement.style.top = this._yCoordinate + 'px';yCoord = this._yCoordinate;}
}
this._layoutForegroundElement(xCoord, yCoord);if (this._dropShadowBehavior) {
this._dropShadowBehavior.setShadow();window.setTimeout(Function.createDelegate(this, this._fixupDropShadowBehavior), 0);}
this._layoutBackgroundElement();},
_layoutForegroundElement : function(xCoord, yCoord) {
if (this._isIE6 && this._relativeOrAbsoluteParentElement) {
var foregroundLocation = $common.getLocation(this._foregroundElement);var relativeParentLocation = $common.getLocation(this._relativeOrAbsoluteParentElement);var getLocationXCoord = foregroundLocation.x;if (getLocationXCoord != xCoord) {
this._foregroundElement.style.left = (xCoord - relativeParentLocation.x) + 'px';} 
var getLocationYCoord = foregroundLocation.y;if (getLocationYCoord != yCoord) {
this._foregroundElement.style.top = (yCoord - relativeParentLocation.y) + 'px';} 
}
},
_layoutBackgroundElement : function() {
if(this._isIE6) { 
var backgroundLocation = $common.getLocation(this._backgroundElement);var backgroundXCoord = backgroundLocation.x;if (backgroundXCoord != 0) {
this._backgroundElement.style.left = (-backgroundXCoord) + 'px';} 
var backgroundYCoord = backgroundLocation.y;if (backgroundYCoord != 0) {
this._backgroundElement.style.top = (-backgroundYCoord) + 'px';} 
}
var clientBounds = $common.getClientBounds();var clientWidth = clientBounds.width;var clientHeight = clientBounds.height;this._backgroundElement.style.width = Math.max(Math.max(document.documentElement.scrollWidth, document.body.scrollWidth), clientWidth)+'px';this._backgroundElement.style.height = Math.max(Math.max(document.documentElement.scrollHeight, document.body.scrollHeight), clientHeight)+'px';},
_fixupDropShadowBehavior : function() {
if (this._dropShadowBehavior) {
this._dropShadowBehavior.setShadow();}
},
_partialUpdateEndRequest : function(sender, endRequestEventArgs) {
AjaxControlToolkit.ModalPopupBehavior.callBaseMethod(this, '_partialUpdateEndRequest', [sender, endRequestEventArgs]);if (this.get_element()) {
var action = endRequestEventArgs.get_dataItems()[this.get_element().id];if ("show" == action) {
this.show();} else if ("hide" == action) {
this.hide();}
}
this._layout();},
_onPopulated : function(sender, eventArgs) {
AjaxControlToolkit.ModalPopupBehavior.callBaseMethod(this, '_onPopulated', [sender, eventArgs]);this._layout();},
get_PopupControlID : function() {
return this._PopupControlID;},
set_PopupControlID : function(value) {
if (this._PopupControlID != value) {
this._PopupControlID = value;this.raisePropertyChanged('PopupControlID');}
},
get_X: function() {
return this._xCoordinate;},
set_X: function(value) {
if (this._xCoordinate != value) {
this._xCoordinate = value;this.raisePropertyChanged('X');}
},
get_Y: function() {
return this._yCoordinate;},
set_Y: function(value) {
if (this._yCoordinate != value) {
this._yCoordinate = value;this.raisePropertyChanged('Y');}
},
get_PopupDragHandleControlID : function() {
return this._PopupDragHandleControlID;},
set_PopupDragHandleControlID : function(value) {
if (this._PopupDragHandleControlID != value) {
this._PopupDragHandleControlID = value;this.raisePropertyChanged('PopupDragHandleControlID');}
},
get_BackgroundCssClass : function() {
return this._BackgroundCssClass;},
set_BackgroundCssClass : function(value) {
if (this._BackgroundCssClass != value) {
this._BackgroundCssClass = value;this.raisePropertyChanged('BackgroundCssClass');}
},
get_DropShadow : function() {
return this._DropShadow;},
set_DropShadow : function(value) {
if (this._DropShadow != value) {
this._DropShadow = value;this.raisePropertyChanged('DropShadow');}
},
get_Drag : function() {
return this._Drag;},
set_Drag : function(value) {
if (this._Drag != value) {
this._Drag = value;this.raisePropertyChanged('Drag');}
},
get_OkControlID : function() {
return this._OkControlID;},
set_OkControlID : function(value) {
if (this._OkControlID != value) {
this._OkControlID = value;this.raisePropertyChanged('OkControlID');}
},
get_CancelControlID : function() {
return this._CancelControlID;},
set_CancelControlID : function(value) {
if (this._CancelControlID != value) {
this._CancelControlID = value;this.raisePropertyChanged('CancelControlID');}
},
get_OnOkScript : function() {
return this._OnOkScript;},
set_OnOkScript : function(value) {
if (this._OnOkScript != value) {
this._OnOkScript = value;this.raisePropertyChanged('OnOkScript');}
},
get_OnCancelScript : function() {
return this._OnCancelScript;},
set_OnCancelScript : function(value) {
if (this._OnCancelScript != value) {
this._OnCancelScript = value;this.raisePropertyChanged('OnCancelScript');}
},
get_repositionMode : function() {
return this._repositionMode;},
set_repositionMode : function(value) {
if (this._repositionMode !== value) {
this._repositionMode = value;this.raisePropertyChanged('RepositionMode');}
},
add_showing : function(handler) {
this.get_events().addHandler('showing', handler);},
remove_showing : function(handler) {
this.get_events().removeHandler('showing', handler);},
raiseShowing : function(eventArgs) {
var handler = this.get_events().getHandler('showing');if (handler) {
handler(this, eventArgs);}
},
add_shown : function(handler) {
this.get_events().addHandler('shown', handler);},
remove_shown : function(handler) {
this.get_events().removeHandler('shown', handler);},
raiseShown : function(eventArgs) {
var handler = this.get_events().getHandler('shown');if (handler) {
handler(this, eventArgs);}
},
add_hiding : function(handler) {
this.get_events().addHandler('hiding', handler);},
remove_hiding : function(handler) {
this.get_events().removeHandler('hiding', handler);},
raiseHiding : function(eventArgs) {
var handler = this.get_events().getHandler('hiding');if (handler) {
handler(this, eventArgs);}
},
add_hidden : function(handler) {
this.get_events().addHandler('hidden', handler);},
remove_hidden : function(handler) {
this.get_events().removeHandler('hidden', handler);},
raiseHidden : function(eventArgs) {
var handler = this.get_events().getHandler('hidden');if (handler) {
handler(this, eventArgs);}
}
}
AjaxControlToolkit.ModalPopupBehavior.registerClass('AjaxControlToolkit.ModalPopupBehavior', AjaxControlToolkit.DynamicPopulateBehaviorBase);AjaxControlToolkit.ModalPopupBehavior.invokeViaServer = function(behaviorID, show) {
var behavior = $find(behaviorID);if (behavior) {
if (show) {
behavior.show();} else {
behavior.hide();}
}
}

//END AjaxControlToolkit.ModalPopup.ModalPopupBehavior.js
if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();
(function() {var fn = function() {$get('tm_HiddenField').value += ';;PK.Framework.Web, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null:en-US:905e5054-f527-4695-83fd-6d8de8721ed9:ef52e453;AjaxControlToolkit, Version=1.0.20229.20821, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e:en-US:0cddd10f-c2cc-4ca8-bbf0-9ac863d6704b:e2e86ef9:9ea3f0e2:9e8e87e9:1df13a87:4c9865be:ba594826:757f92c2:3858419b:96741c43:c4c00916:c7c04611:cd120801:38ec41c0';Sys.Application.remove_load(fn);};Sys.Application.add_load(fn);})();
