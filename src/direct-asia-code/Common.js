var isIE6 = /msie|MSIE 6/.test(navigator.userAgent);
var isIE = /msie|MSIE /.test(navigator.userAgent);
var __monthlyPaymerntTerm = 1000006;
var __rsSingaporean = 1000000;
var __rsPR = 1000001;
var __rsPassHolder = 1000002;
var __Other = 1000003;
var __secureLoginUrl;
var __PKServerDate;
var __PKTimeInterval = null;
var __ServerDate = null;
function LoadFlash(flashPath, divId, width, height, autoPlay)
{
    var flashvars = {};
    var params = {};
    params.wmode = "transparent";
    params.play = autoPlay;
    var attributes = {};
    attributes.id = divId;
    swfobject.embedSWF(flashPath, divId, width, height, "9.0.0", false, flashvars, params, attributes);
};
var NricLastChar = new Array("J", "Z", "I", "H", "G", "F", "E", "D", "C", "B", "A");
var FinLastChar = new Array("X", "W", "U", "T", "R", "Q", "P", "N", "M", "L", "K");
function ValidateNricFinNumber(source, args)
{
    var nric = $get(source.controltovalidate);
    var needtov = nric.getAttribute("nric"); 
    if( needtov == 0 )
    {
        args.IsValid = true;
        return;
    }
    var nricStr = nric.value;
    if( nricStr.length != 9 )
    {
        args.IsValid = false;
        return;
    }
    if(/^[S,T,F,G]\d{7}[A-Z]$/.test(nricStr) == false)
    {
        args.IsValid = false;
        return;
    }
    var total = 0;
    total += nricStr.substr(1, 1) * 2;
    total += nricStr.substr(2, 1) * 7;
    total += nricStr.substr(3, 1) * 6;
    total += nricStr.substr(4, 1) * 5;
    total += nricStr.substr(5, 1) * 4;
    total += nricStr.substr(6, 1) * 3;
    total += nricStr.substr(7, 1) * 2;
    var firstChar = nricStr.substr(0,1);
    var lastChar = nricStr.substr(8,1);
    if( firstChar == "T" || firstChar == "G") {total += 4;}
    var remainder = total%11;
    var lastCharComputed;
    if( firstChar == "S" || firstChar == "T")
    {
        lastCharComputed = NricLastChar[remainder];
    }
    else
    {
        lastCharComputed = FinLastChar[remainder];
    }
    if( lastCharComputed == lastChar)
    {
        args.IsValid = true;
    }
    else
    {
        args.IsValid = false;
    }
};
function _initServerDate()
{
    if(!__ServerDate)
    {
        setTimeout("_initServerDate()", 200);
        return;
    }
    __PKServerDate = new Date(__ServerDate);
    if( __PKTimeInterval != null)
    {
        window.clearInterval(__PKTimeInterval);
    }
    __PKTimeInterval = setInterval("updateServerTime()", 1000);
}
function updateServerTime()
{
    var secs = __PKServerDate.getSeconds();
    __PKServerDate= new Date(__PKServerDate.setSeconds(secs + 1));
}
//try
//{
//    window.history.forward();
//}
//catch(err){}
function __noBack()
{
     window.history.forward();
}
$(document).ready(function(){
    //__noBack();
    _initServerDate();
});
function getAge(Y,M,D)
{    
    var now;
    if( __PKServerDate != null ) {now = __PKServerDate;}
    else {now = new Date();}
    var m=now.getMonth()+1,d=now.getDate();
    return now.getFullYear()-Y+(M>m?-1:M==m&&D>d?-1:0);
};
function getAgeByDate(Y,M,D, dt)
{    
    var now = dt;
    var m=now.getMonth()+1,d=now.getDate();
    return now.getFullYear()-Y+(M>m?-1:M==m&&D>d?-1:0);
};
function CurrentDateTime()
{
    var now;
    if( __PKServerDate != null ) {now = __PKServerDate;}
    else {now = new Date();}
    return now;
}
function DateAddDays(dtObj, numDays)
{
    var day=1000*60*60*24;
    var dVal=dtObj.valueOf();
    return new Date(dVal+day*numDays);
};
var monthDay = new Array(31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
function DateAddMonths(dtObj, numMonths)
{
    var targetmonth = 0;
    var targetyear = 0;
    var targetday = 0;
    
    var m = dtObj.getMonth() + 1;
    var y = dtObj.getFullYear();
    var d = dtObj.getDate();
    
    targetyear = y + Math.floor((m + numMonths)/12);
    targetmonth = (m + numMonths) % 12;

    
    var maxdayinmonth = monthDay[targetmonth-1];
    if(targetmonth == 2)
    {
        //check whether is leap year
        if(IsLeapYear(new Date(targetyear,targetmonth-1,1)))
            maxdayinmonth = 29;
        else
            maxdayinmonth = 28;
    }
    
    if(d > maxdayinmonth)
        targetday = maxdayinmonth;
    else
        targetday = d;
        
    return new Date(targetyear,targetmonth-1,targetday);
}
function DateDiff(fromDate, toDate)
{
    var increment = 0;
    var day = 0, month = 0, year = 0;
    if( fromDate.getDate() > toDate.getDate() )
    {
        increment  = monthDay[fromDate.getMonth()];
    }   
    if( increment == -1 )
    {
        if(IsLeapYear(fromDate))
        {
            increment = 29;
        }
        else
        {
            increment = 28;
        }
    }     
    if( increment != 0 )
    {
        day = (toDate.getDate() + increment) - fromDate.getDate();
        increment = 1;
    }
    else
    {
        day = toDate.getDate() - fromDate.getDate();
    }  
    if ((fromDate.getMonth() + increment) > toDate.getMonth())
    {
        month = (toDate.getMonth() + 12) - (fromDate.getMonth() + increment);
        increment = 1;
    }
    else
    {
        month = (toDate.getMonth()) - (fromDate.getMonth() + increment);
        increment = 0;
    }
    year = toDate.getFullYear() - (fromDate.getFullYear() + increment);
    var diff = new Object();
    diff.Years = year;
    diff.Months = month;
    diff.Days = day;
    return diff;
};
function IsLeapYear(utc) 
{
    var y = utc.getFullYear();
    return !(y % 4) && (y % 100) || !(y % 400) ? true : false;
};
function cvValidateMainDriverAge(source, args)
{
    //format dd-mm-yyyy
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var age = getAge(y,m,d);
        if( age < 25 || age > 65)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }    
};
function cvValidateMainDriverAge_Motorcycle(source, args)
{
    //format dd-mm-yyyy
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2)*1;
        var m = txt.substr(3,2)*1;
        var y = txt.substr(6,4)*1;
        
        var txtPS = $("#txtPolicyStartDate").val();
        if( txtPS == ""  ||
            !/\d{2}[-]\d{2}[-]\d{4}/.test(txtPS))
        {
            args.IsValid = true;
            return;
        }    
        
        var age = getAgeByDate(y,m,d, GetDateFromString_Motorcycle(txtPS));
        if( age < 25 || age > 65)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }    
};
function GetDateFromString_Motorcycle(txt)
{
    var d = txt.substr(0,2);
    var m = txt.substr(3,2);
    var y = txt.substr(6,4);
    return new Date(y,m*1-1,d*1, 0, 0, 0);    
}
function GetDateFromString(txt)
{
    var d = txt.substr(0,2);
    var m = txt.substr(3,2);
    var y = txt.substr(6,4);
    return new Date(y,m*1-1,d*1+1, 0, 0, 0);    
}
function cvValidatePolicyHolderAge(source, args)
{
    //format dd-mm-yyyy
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var age = getAge(y,m,d);
        if( age < 18)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }    
};
function cvValidatePAPolicyHolderAge(source, args)
{
    //format dd-mm-yyyy
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var age = getAge(y,m,d);
        if( age < 18 || age > 65)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }    
};
function cvReqYoungDriverAgeGender(source, args)
{
    var txt = $get(source.controltovalidate);
    var rblValue = ValidatorGetValue(txt.getAttribute("refid"));
    if( (txt.value == "" || txt.value.toUpperCase() == "DD-MM-YYYY") && rblValue != "")
    {
        args.IsValid = false;
        return;
    }
    args.IsValid = true;
};
function cvReqYoungDriverGenderAge(source, args)
{
    var rblValue = ValidatorGetValue(source.controltovalidate);
    var txt = $get($get(source.controltovalidate).getAttribute("refid"));
    if( txt.value.toUpperCase() != "DD-MM-YYYY" )
    {
        if( txt.value != "" && rblValue == "")
        {
            args.IsValid = false;
            return;
        }
    }
    args.IsValid = true;
};


function cvValidateYoungDriverAge(source, args)
{
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var age = getAge(y,m,d);
        if( age < 18  || age > 70)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }   
};


function cvValidateYoungDriverAgeMotorCycle(source, args)
{
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var txtPS = $("#txtPolicyStartDate").val();
        if( txtPS == ""  ||
            !/\d{2}[-]\d{2}[-]\d{4}/.test(txtPS))
        {
            args.IsValid = true;
            return;
        }  
        var age = getAgeByDate(y,m,d, GetDateFromString_Motorcycle(txtPS));
        if( age < 25  || age > 65)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }   
};
function formatCurrency(num) 
{
    num = num.toString().replace(/\$|\,/g,'');
    if(isNaN(num)) num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    cents = num%100;
    num = Math.floor(num/100).toString();
    if(cents<10)
    cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
    num = num.substring(0,num.length-(4*i+3))+','+
    num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + 'S$' + num + '.' + cents);
};
function validatorUpdateDisplay(val)
{
    if (val.isvalid) 
    {
        //make the error invisible
        val.display = "none";
    }
    else 
    {
        var browser = navigator.appName;
        //different browsers get updated differently, IE really the only main one to update differently.
        if (browser == "Microsoft Internet Explorer") 
        {
            val.ValidatorCalloutBehavior._errorMessageCell.innerText = val.errormessage;
        }
        else 
        {
            val.ValidatorCalloutBehavior._errorMessageCell.textContent = val.errormessage;
        }
        //make the error visible
        val.display = "inline";
    }          
};
function ShowLoginPopups(strUrl)
{
    //for day1 only 
    /*
    var newUrl = strUrl.toLowerCase().replace("login.aspx", "login_coming_soon.html");
    setTimeout(function(){__ShowLB_FrameDelay('','', "730px", "400px", newUrl);},50);
    */    
    //Commented for day1. should change back when login function is ready.
    
    if( document.location.href.startsWith("https://"))
        setTimeout(function(){__ShowLB_FrameDelay('','', "680px", "400px", strUrl);},50);
    else
        top.location.href = __secureLoginUrl;    
   
};
function ShowChangePassword(strUrl)
{
    setTimeout(function(){__ShowLB_FrameDelay('','', "680px", "400px", strUrl);},50);
}
function ShowLoginPopupsSize(strUrl, Width, Height)
{
    setTimeout(function(){__ShowLB_FrameDelay('','', Width, Height, strUrl);},50);
};
function formatDate(formatDate, formatString) {
	if(formatDate instanceof Date) {
		var months = new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
		var yyyy = formatDate.getFullYear();
		var yy = yyyy.toString().substring(2);
		var m = formatDate.getMonth()+1;
		var mm = m < 10 ? "0" + m : m;
		var mmm = months[m];
		var d = formatDate.getDate();
		var dd = d < 10 ? "0" + d : d;
		
		var h = formatDate.getHours();
		var hh = h < 10 ? "0" + h : h;
		var n = formatDate.getMinutes();
		var nn = n < 10 ? "0" + n : n;
		var s = formatDate.getSeconds();
		var ss = s < 10 ? "0" + s : s;

		formatString = formatString.replace(/yyyy/i, yyyy);
		formatString = formatString.replace(/yy/i, yy);
		formatString = formatString.replace(/mmm/i, mmm);
		formatString = formatString.replace(/mm/i, mm);
		formatString = formatString.replace(/m/i, m);
		formatString = formatString.replace(/dd/i, dd);
		formatString = formatString.replace(/d/i, d);
		formatString = formatString.replace(/hh/i, hh);
		formatString = formatString.replace(/h/i, h);
		formatString = formatString.replace(/nn/i, nn);
		formatString = formatString.replace(/n/i, n);
		formatString = formatString.replace(/ss/i, ss);
		formatString = formatString.replace(/s/i, s);

		return formatString;
	} else {
		return "";
	}
}; 
function HideValidatorsInGroup(GroupName)
{
   for (var vI = 0; vI < Page_Validators.length; vI++)
   {
     var vVal = Page_Validators[vI];
     if (IsValidationGroupMatch(vVal, GroupName))
     {
        vVal.isvalid = true;
        ValidatorUpdateDisplay(vVal);
     }
   }
}
/* tooltip Jquery core is required*/
var timer_toolTip = null;
var g_PopupIFrame = null;
function ShowToolTip(ctlId, contentDivId)
{
    if( timer_toolTip != null )
    {
        window.clearTimeout(timer_toolTip);
    }
    var ttp = $("#pkToolTip");
    if( ttp.css("display") != "none")
    {
        return;
    }
    var obj = $("#"+ctlId);
    var ttCon = $("#toolTipContent");
    var pos = obj.offset();
    var left = pos.left + obj.width();
    //if( !isIE ) left += 13;
    var top = pos.top + obj.height()/2;
    ttp.css("top", top+"px");
    ttp.css("left", left+"px");
    ttCon.html($("#"+contentDivId).html());
    setTimeout("SetContentContainerSize()", 50);
    if( isIE6 )
    {
        var iFrame;
        if(!g_PopupIFrame) iFrame= document.createElement("IFRAME");
        else iFrame = g_PopupIFrame;
        iFrame.setAttribute("src", "");
        if(!g_PopupIFrame)
        {
            g_PopupIFrame= iFrame;
            document.body.appendChild(iFrame);
        }
    }
    if( isIE ) ttp.show();
    else ttp.fadeIn();  
}
function SetContentContainerSize()
{
    var height = $("#toolTipContent").height();
    $("#toolTipConentBg").height(height);
    if( isIE6 )
    {
        ie6PngFix('#pkToolTip .png_img', 'image');
        ie6PngFix('#pkToolTip .png_img_scale', 'scale');
        if(g_PopupIFrame)
        {
            var objTipLayer = $("#pkToolTip");
            var iframe = $(g_PopupIFrame);
            iframe.css({position:"absolute", display:"", opacity:0 });
            iframe.css("left", objTipLayer.position().left+'px');
            iframe.css("top", objTipLayer.position().top+'px');
            iframe.width(objTipLayer.width());
            iframe.height(objTipLayer.height());
        } 
    }
}
function ie6PngFix(selector, sizeMethod) 
{
    $(selector).each(
        function() 
        {
            if (document.all)
            {
                this.parentNode.style.width = this.offsetWidth;
                this.parentNode.style.height = this.offsetHeight;
                this.parentNode.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=" + sizeMethod + " src='" + this.src + "')"
                this.style.visibility = 'hidden';
            } 
            else 
            {
                this.style.visibility = 'visible';
            }
        }
    );
}
function HideToolTip()
{
    if( timer_toolTip != null )
    {
        window.clearTimeout(timer_toolTip);
    }
    timer_toolTip = setTimeout(function(){
        if(isIE){$("#pkToolTip").hide();}
        else{$("#pkToolTip").fadeOut()}
        if(g_PopupIFrame)
        {
            var iframe = $(g_PopupIFrame);
            iframe.css("display", "none");
        }   
    }, 20);
}
function AttachToolTipEvent(ctlId, contentDivId)
{
    var trg = $("#"+ctlId);
    trg.hover(
        function() {ShowToolTip(ctlId, contentDivId);},
        function() {HideToolTip();}
    );
    trg.focus(function() {ShowToolTip(ctlId, contentDivId);});
    trg.blur(function() {HideToolTip();});
    var ttp = $("#pkToolTip");
    ttp.hover(
        function() {ShowToolTip(ctlId, contentDivId);},
        function() {HideToolTip();}
    );
    ttp.focus(function() {ShowToolTip(ctlId, contentDivId);});
    ttp.blur(function() {HideToolTip();});
}
/* End of tooltip */
function ScrollToControl(cid)
{
    var page = (window.opera)? (document.compatMode=="CSS1Compat"? $('html') : $('body')) : $('html,body')
    var dest = $('#'+cid).offset().top;
    page.animate({scrollTop: dest}, 1000);
}
function Redirect(url)
{
    __ShowLBLoading();
    setTimeout(function(){window.location.href=url;}, 10);
}

function AttachHelpDirectEvent(containerClientId, pnlHtmlTextClientId)
{
    var con = $("#" + containerClientId);
    var inputs = $(":input", con);
    var chks = $(":checkbox", con);
    var radios = $(":radio", con);
    var eventName = "focus";
    var eventHandler = function(){SetHelpDirectText(pnlHtmlTextClientId)};
    //remove event handler
    inputs.unbind(eventName, eventHandler);
    chks.unbind(eventName, eventHandler);
    radios.unbind(eventName, eventHandler);
    //attach event handler
    inputs.bind(eventName, eventHandler);
    chks.bind(eventName, eventHandler);
    radios.bind(eventName, eventHandler);  
}
function AttachHelpDirectEventSingle(ctlClientId, oldPnlHtmlTextClientId, pnlHtmlTextClientId)
{
    var jCtl = $("#" + ctlClientId);
    var eventName = "focus";
    var oldEventHandler = function(){SetHelpDirectText(oldPnlHtmlTextClientId)};
    var newEventHandler = function(){SetHelpDirectText(pnlHtmlTextClientId)};
            
    //remove old handler
    jCtl.unbind(eventName, oldEventHandler);
    //add new handler
    jCtl.bind(eventName, newEventHandler);
}
function AttachHelpDirectEventSingleToLabel(ctlClientId, oldPnlHtmlTextClientId, pnlHtmlTextClientId)
{
    var jCtl = $("#" + ctlClientId);
    var eventName = "mouseover";
    var oldEventHandler = function(){SetHelpDirectText(oldPnlHtmlTextClientId)};
    var newEventHandler = function(){SetHelpDirectText(pnlHtmlTextClientId)};
            
    //remove old handler
    jCtl.unbind(eventName, oldEventHandler);
    //add new handler
    jCtl.bind(eventName, newEventHandler);
}
function SetHelpDirectText(pnlHtmlTextClientId)
{
    $("#divRightBanner").html($("#"+pnlHtmlTextClientId).html());
}

jQuery.fn.tagName = function(){
        if(1 === this.length){
                return this[0].tagName.toLowerCase();
        } else{
                var tagNames = [];
                this.each(function(i, el){
                        tagNames[i] = el.tagName.toLowerCase();
                });
                return tagNames;
        }
};
function HighlightReadonlyTextBox()
{
    var inputs = $(":input");
    inputs.each(function(){
        var ctl = $(this);
        var tp = ctl.attr("type");
        if( tp == "radio" || tp == "image" || tp == "hidden" || tp=="checkbox" )
        {
            return true;
        }
        ctl.removeClass("readonly");
        if( ctl.attr("readonly") || ctl.attr("disabled"))
        {
            ctl.addClass("readonly");
        }
    });
}
function FixIESelectOptionWith()
{
    if( isIE6 ) return;
    if( isIE && (navigator.userAgent.indexOf("Trident/5")>-1) )
    {
        return;
    }
    var inputs = $("select");
    inputs.each(function(){
        var ctl = $(this);
        if(!ctl.attr("disabled") && checkOptinLength(ctl) && ctl.attr("ignore") != "1")
        {
            ctl.wrap("<div id='dv_" + ctl.attr("id") +  "' style='overflow:hidden;width:" + ctl.css("width") + ";'></div>");
            ctl.mousedown(function(){
                var ctl = $(this);
                //var curWidth = $("#dv_" +ctl.attr("id")).width();
                ctl.css("width", "auto");
                //if( ctl.width() < curWidth ) ctl.css("width", curWidth);
            })
            ctl.blur(function(){
                $(this).css("width", $("#dv_" +$(this).attr("id")).css("width"));
                
            });
            ctl.change(function(){
                $(this).css("width", $("#dv_" +$(this).attr("id")).css("width"));
            });
        }
    });
}
function checkOptinLength(ctl)
{
    var w1 = ctl.width();
    var w2 = ctl.css("width");
    ctl.css("width", "auto");
    var w3 = ctl.width();
    ctl.css("width", w2);
    if( w1 > w3 ) return false;
    return true;
}

//disbale Enter Key
function checkKeyPressed(evt)
{
    if (evt.which == 13) {
        return false;
     }
     if( evt.which == 8 )
     {
        var target = $(evt.target);
        var tagName = target.tagName();
        //if is textbox, area, and editable return true, 
        //else return false;
        if( tagName == "input" || tagName == "textarea" )
        {
            if( target.attr("readonly") == false && target.attr("disabled") == false )
            {
                return true;
            }
        }
        return false;
     }
}
if( $.browser.msie )
{
    $(document).keydown(function (evt) {return checkKeyPressed(evt);}); 
}
else
{
    $(document).keypress(function (evt) {return checkKeyPressed(evt);}); 
}
function focus(ctlId)
{
    $("#"+ctlId).focus();
}
function focusDelay(ctlId)
{
    setTimeout(function(){focus(ctlId);}, 200);
}
function setContainerHeight(id)
{
    var s = $("#"+id);
    var p = s.parent();
    var minH = s.height() - 80;
    if( p.height() < minH )
    {
        p.height(minH);
    }
}
function EmailConfirmButtonClicked(mpeBid)
{
    setTimeout(function(){
        if (typeof(Page_IsValid) == 'boolean') 
        {
            if (Page_IsValid == true) 
            {
                $find(mpeBid).hide();
                __ShowLoadingDig();
                return;    
            }
        }
    }, 50);
}
function isScrolledIntoView(elem)
{
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return ((elemBottom >= docViewTop) && (elemTop <= docViewBottom)
      && (elemBottom <= docViewBottom) &&  (elemTop >= docViewTop) );
}
//GA
var __redirectUrl = "";
function SaveExistRedirect(url, GAUrl)
{
    __redirectUrl = url;
    top.__ShowLBLoading();
    setTimeout(function(){TransactionGALoaded();}, 5000);
    $(document.body).append('<iframe id="__ifGATR" style="display:none;"></iframe>');
    $("#__ifGATR").attr("src", GAUrl);
}
function TransactionGALoaded()
{
    top.location.href=__redirectUrl;
};
//Unit Number
function AddressUnitNumberOnBlur(tId, hId, title, message)
{
    var h = $("#" + hId);
    var t = $("#" + tId);
    if( h.val() != '' ) return;
    if( t.val() != '' ) return;
    
    top.ShowMessageLBDelay(title, message, '', 1, '$("#'+hId+'").val("1");')
}

function PrintPolicy()
{
    $("#pnlRight").css("position", "");
    window.print();
    $("#pnlRight").css("position", "absolute");
}

function IsCCExpiredForMonthly(cc)
{
    if( $("#hfIsMonthly").val() != "1")
    {
        return false;
    }
    
    var dueDate = $("#hfPayDueDate").val() * 1;
    var dtCC = ("20" + cc.substr(2,2) + cc.substr(0,2))*1;
    
    if( dtCC < dueDate )
        return true;
    else
        return false;    
}


function cvVehicleRegNoMotor_Client(source, args)
{
    args.IsValid = IsValidMotorVehicleRegNo($("#"+source.controltovalidate).val());
}

function IsValidMotorVehicleRegNo(strNo)
{
    strNo = strNo.toUpperCase();
    var length = strNo.length;
    
    if( !/^[ES][A-Z]{1,2}[0-9]{0,4}[A-Z]$/.test(strNo) )
        return false;
        
    var checkLetter = new Array("A","Y","U","S","P","L","J","G","D","B","Z","X","T","R","M","K","H","E","C");    
    var charNumber = new Array();
    populateCharNumberArrayForMotorcycle(charNumber);
    
    var total = 0;
    
    var code=new Array(strNo.length);
    for(var i=0;i<strNo.length;i++){
    code[i]=strNo.charCodeAt(i);
    
     }

    if (code[2] >= 65 && code[2] <= 90)
    { }
    else
        strNo= "0"+strNo;
    lemmngth = strNo.length;
    
    var ch = strNo.substr(1,1);
    
    total = charNumber[ch]*14 + total;
    
    ch = strNo.substr(2,1);
    total = charNumber[ch]*2 + total;
    
    var index = 3;
    if( length == 8)
    {
        ch = strNo.substr(index,1);
        total = charNumber[ch]*12 + total;
        index++;
    }
    
    if( length >= 7)
    {
        ch = strNo.substr(index,1);
        total = charNumber[ch]*2 + total;
        index++;
    }
    
    if( length >= 6 )
    {
        ch = strNo.substr(index,1);
        total = charNumber[ch]*11 + total;
        index++;
    }
    
    ch = strNo.substr(index,1);
    total = charNumber[ch]*1 + total;
    index++;
    
   // alert(total);
    var rem = total%19;
    ch = strNo.substr(index,1);
    //alert(ch);
    if( ch == checkLetter[rem])
        return true;
    else
        return false;
}


function cvVehicleRegNo_Client(source, args)
{
    args.IsValid = IsValidMotorcycleVehicleRegNo($("#"+source.controltovalidate).val());
}

function IsValidMotorcycleVehicleRegNo(strNo)
{
    strNo = strNo.toUpperCase();
    var length = strNo.length;
    
    if( !/^[AF][A-Z]{1,2}[0-9]{0,4}[A-Z]$/.test(strNo) )
        return false;
        
    var checkLetter = new Array("A","Y","U","S","P","L","J","G","D","B","Z","X","T","R","M","K","H","E","C");    
    var charNumber = new Array();
    populateCharNumberArrayForMotorcycle(charNumber);
    
    var total = 0;
    
    var code=new Array(strNo.length);
    for(var i=0;i<strNo.length;i++){
    code[i]=strNo.charCodeAt(i);
    
     }

    if (code[2] >= 65 && code[2] <= 90)
    { }
    else
        strNo= "0"+strNo;
    length = strNo.length;
    
    var ch = strNo.substr(1,1);
    
    total = charNumber[ch]*14 + total;
    
    ch = strNo.substr(2,1);
    total = charNumber[ch]*2 + total;
    
    var index = 3;
    if( length == 8)
    {
        ch = strNo.substr(index,1);
        total = charNumber[ch]*12 + total;
        index++;
    }
    
    if( length >= 7)
    {
        ch = strNo.substr(index,1);
        total = charNumber[ch]*2 + total;
        index++;
    }
    
    if( length >= 6 )
    {
        ch = strNo.substr(index,1);
        total = charNumber[ch]*11 + total;
        index++;
    }
    
    ch = strNo.substr(index,1);
    total = charNumber[ch]*1 + total;
    index++;
    
   // alert(total);
    var rem = total%19;
    ch = strNo.substr(index,1);
    //alert(ch);
    if( ch == checkLetter[rem])
        return true;
    else
        return false;
}
function populateCharNumberArrayForMotorcycle(charNumber)
{
    charNumber["A"] = 1;
    charNumber["B"] = 2;
    charNumber["C"] = 3;
    charNumber["D"] = 4;
    charNumber["E"] = 5;
    charNumber["F"] = 6;
    charNumber["G"] = 7;
    charNumber["H"] = 8;
    charNumber["I"] = 9;
    charNumber["J"] = 10;
    charNumber["K"] = 11;
    charNumber["L"] = 12;
    charNumber["M"] = 13;
    charNumber["N"] = 14;
    charNumber["O"] = 15;
    charNumber["P"] = 16;
    charNumber["Q"] = 17;
    charNumber["R"] = 18;
    charNumber["S"] = 19;
    charNumber["T"] = 20;
    charNumber["U"] = 21;
    charNumber["V"] = 22;
    charNumber["W"] = 23;
    charNumber["X"] = 24;
    charNumber["Y"] = 25;
    charNumber["Z"] = 26;
    
    charNumber["0"] = 0;
    charNumber["1"] = 1;
    charNumber["2"] = 2;
    charNumber["3"] = 3;
    charNumber["4"] = 4;
    charNumber["5"] = 5;
    charNumber["6"] = 6;
    charNumber["7"] = 7;
    charNumber["8"] = 8;
    charNumber["9"] = 9;
}
// Purchasing Year

var __defYear = null;
var __popupYearFocus = false;
function selectPurchaseYear(divCtl, val) {
    //var txt = $.trim($(divCtl).text());
    //setYear(txt, id);
    setYear(val, val);
}
function setYear(txt, id) {
    $("#txtFirstYearOfReg").val(txt);
    $("#hfFirstYearOfReg").val(txt);
    $find("pcePurchaingYear").hidePopup();
    var validator = document.getElementById('txtFirstYearOfReg_Rfv');
    if( validator) ValidatorValidate(validator);
    FilterYear();
    __defYear = null;
    if(typeof ShowConfirmBtn == 'function') {
        ShowConfirmBtn();
    }
}
function clearYear() {
    $("#hfFirstYearOfReg").val('');
}
function txtYearDisplay_Blur() {
    setTimeout(function () {
        if ($("#hfFirstYearOfReg").val() == '' && __popupYearFocus == false) {
            if (__defYear != null) {
                var id = __defYear.attr("id").replace("pm_", "");
                selectPurchaseYear(__defYear, id);
            }
            else {
                $("#txtFirstYearOfReg").val('');
            }
        }
    }, 100);
}
function txtYearDisplay_Keydown() {
    __popupYearFocus = false;
    clearYear();
    FilterYear();
}
function pnlYearPopup_MouseOver() {
    __popupYearFocus = true;
}
function pnlYearPopup_MouseOut() {
    __popupYearFocus = false;
}
function FilterYear() {
    __defYear = null;
    var va = $("#txtFirstYearOfReg").val().toLowerCase();
    var list = $("#pnlPurchaseYear");
    $(".popup_Model_list_item", list).each(function () {
        var dv = $(this);
        var txt = $.trim(dv.text()).toLowerCase();
        if (va == '' || va.length == 0 || txt.indexOf(va) == 0) {
            dv.show();
            dv.removeClass("popup_Model_list_item_selected");
            if (__defYear == null) {
                dv.addClass("popup_Model_list_item_selected");
                __defYear = dv;
            }
        }
        else {
            dv.hide();
        }
    });
}
function TriggerValidator(vdId, grpName) {
    var validator = document.getElementById(vdId);
    if( validator)
    {
        ValidatorValidate(validator);
        ValidatorUpdateIsValid();
        ValidationSummaryOnSubmit(grpName);
    }
}


function cvChildAgeVisible_SOS(source, args)
{

   var ctl = $("#"+source.controltovalidate);
    var trId = ctl.attr("trId");
    
    if($("#"+trId).css("display") == "none")
    {
        //alert('if:trId='+trId);
        args.IsValid = true;
        return;
    }
    else
    {
       var txt = ValidatorGetValue(source.controltovalidate);
       // alert('else:ddlValue='+ddlValue);
        
        if(txt=='')
        {
        args.IsValid = false;        
        return; 
        }
    }
     args.IsValid = true;
};

function cvClaimDetails_SOS(source, args)
{


    var ctl = $("#"+source.controltovalidate);
    var trId = ctl.attr("trId");
    
    if($("#"+trId).css("display") == "none")
    {
        //alert('if:trId='+trId);
        args.IsValid = true;
        return;
    }
    else
    {
       var ddlValue = ValidatorGetValue(source.controltovalidate);
       // alert('else:ddlValue='+ddlValue);
        if( ctl.tagName() == "select")
        {
        if(ddlValue=='0')
        {
        args.IsValid = false;        
        return; 
        }
        }
        else
        {
        if(ddlValue=='')
        {
        args.IsValid = false;        
        return; 
        }
        }
        
        
    }
     args.IsValid = true;
};



function cvReqClaimAccidentForND1_SOS(source, args)
{
    var txt = ValidatorGetValue(source.controltovalidate);
    var ddlRelValue = $get($get(source.controltovalidate).getAttribute("refid"));
    var txtDOB = $get($get(source.controltovalidate).getAttribute("refid1"));    
    var ddlGenderValue = $get($get(source.controltovalidate).getAttribute("refid2"));
       
    if( ddlRelValue.value != "0" && txtDOB.value.toUpperCase() != "DD-MM-YYYY" && ddlGenderValue.value !="0")
    {      if(txt=="")
            {
            args.IsValid = false;
            return;        
            }
    }
    args.IsValid = true;
};
function cvReqClaimAccidentForND2_SOS(source, args)
{
    var txt = ValidatorGetValue(source.controltovalidate);
    var ddlRelValue = $get($get(source.controltovalidate).getAttribute("refid"));
    var txtDOB = $get($get(source.controltovalidate).getAttribute("refid1"));    
    var ddlGenderValue = $get($get(source.controltovalidate).getAttribute("refid2"));
       
    if( ddlRelValue.value != "0" && txtDOB.value.toUpperCase() != "DD-MM-YYYY"  && ddlGenderValue.value !="0")
    {      if(txt=="")
            {
            args.IsValid = false;
            return;        
            }
    }
    args.IsValid = true;
};
//Relationship
function cvReqYoungDriverRelAgeNricGender_SOS(source, args)
{
    var ddlValue = ValidatorGetValue(source.controltovalidate);
    var txt = $get($get(source.controltovalidate).getAttribute("refid"));     
     var ddlGenderValue = $get($get(source.controltovalidate).getAttribute("refid1"));
    
    
    if( txt.value.toUpperCase() != "DD-MM-YYYY" || ddlGenderValue.value !="0")
    {
        if( (txt.value.toUpperCase() != "DD-MM-YYYY" || ddlGenderValue.value !="0") && ddlValue == "0")
        {
            args.IsValid = false;
            return;
        }
    }
    args.IsValid = true;
};
//DOB
function cvReqYoungDriverAgeRelNricGender_SOS(source, args)
{
   var txt = $get(source.controltovalidate);    
    var ddlRelValue = $get($get(source.controltovalidate).getAttribute("refid"));    
    var ddlGenderValue = $get($get(source.controltovalidate).getAttribute("refid1"));
    
    
    if( ddlRelValue.value != "0" || ddlGenderValue.value !="0" )
    {
        if( txt.value.toUpperCase() == "DD-MM-YYYY")
        {
            args.IsValid = false;
            return;
        }
    }
    args.IsValid = true;
};

//Gender
function cvReqYoungDriverGenderRelAgeNric_SOS(source, args)
{
    var ddlValue = ValidatorGetValue(source.controltovalidate); 
    var ddlRelValue = $get($get(source.controltovalidate).getAttribute("refid"));    
    var txtDOB = $get($get(source.controltovalidate).getAttribute("refid1"));    
    
    if( ddlRelValue.value != "0" || txtDOB.value.toUpperCase() != "DD-MM-YYYY")
    {
        if(ddlValue == "0")
        {
            args.IsValid = false;
            return;
        }
    }
    args.IsValid = true;
};
//


/*Start: SOS*/
         
function cvReqYoungDriverAgeRelation_SOS(source, args)
{
    var txt = $get(source.controltovalidate);
    var rblValue = ValidatorGetValue(txt.getAttribute("refid"));
    if( (txt.value == "" || txt.value.toUpperCase() == "DD-MM-YYYY") && rblValue != "")
    {
        args.IsValid = false;
        return;
    }
    args.IsValid = true;
};
function cvReqYoungDriverRelationAge_SOS(source, args)
{
    var rblValue = ValidatorGetValue(source.controltovalidate);
    var txt = $get($get(source.controltovalidate).getAttribute("refid"));
    if( txt.value.toUpperCase() != "DD-MM-YYYY" )
    {
        if( txt.value != "" && rblValue == "")
        {
            args.IsValid = false;
            return;
        }
    }
    args.IsValid = true;
};



function cvReqClaimMonth_SOS(source, args)
{   
    var txt = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));       
      
    if(!((txt1.value == "0" || txt1.value == "") && (txt2.value == "0" || txt2.value == "") && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
        if( (txt == "" || txt.toUpperCase() == "DD") )
        {        
            args.IsValid = false;
            return;        
        }
    }      
    args.IsValid = true;
};

function cvReqClaimYear_SOS(source, args)
{   
    var txt = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));       
      
    if(!((txt1.value == "0" || txt1.value == "") && (txt2.value == "0" || txt2.value == "") && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
        if( (txt == "" || txt.toUpperCase() == "YYYY") )
        {        
            args.IsValid = false;
            return;        
        }
    }      
    args.IsValid = true;
};

function cvReqNatureOfClaims_SOS(source, args)
{   var ddlValue = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));
       
    if(!((txt1.value == "0" || txt1.value == "") && (txt2.value == "0" || txt2.value == "") && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
        if(ddlValue=='0')
        {        
            args.IsValid = false;
            return;        
        }
    }      
    args.IsValid = true;
};

function cvReqVechileAccidentInvolved_SOS(source, args)
{   var rblValue = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));
       
    if(!((txt1.value == "0" || txt1.value == "") && (txt2.value == "0" || txt2.value == "") && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
        if(rblValue=='')
        {        
            args.IsValid = false;
            return;        
        }
    }      
    args.IsValid = true;
};
function cvValidateMainDriverAge_SOS(source, args)
{
    //format dd-mm-yyyy
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var age = getAge(y,m,d);
        if( age < 25 || age > 65)
        {
            args.IsValid = false;           
        }
        else
        {
            args.IsValid = true;           
        }
    }
    else
    {
        args.IsValid = true;      
    }    
};

function cvValidateYoungDriverAge_SOS(source, args)
{
    var txt = $get(source.controltovalidate).value;
    if( /\d{2}[-]\d{2}[-]\d{4}/.test(txt) )
    {
        var d = txt.substr(0,2);
        var m = txt.substr(3,2);
        var y = txt.substr(6,4);
        var age = getAge(y,m,d);
        if( age < 18  || age > 70)
        {
            args.IsValid = false;
        }
        else
        {
            args.IsValid = true;
        }
    }
    else
    {
        args.IsValid = true;
    }   
};


//10-07-12
function cvClaimMonth_SOS(source, args)
{   
    var txt = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));       
    var txt5 = $get($get(source.controltovalidate).getAttribute("refid4"));  
     
    if(!(txt1.value == "0" && txt2.value == "0" && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
       var currentYear = (new Date).getFullYear(); 
       var fullDate = new Date()
       var currentMonth = ((fullDate.getMonth().length+1) === 1)? (fullDate.getMonth()+1) : '0' + (fullDate.getMonth()+1);
       
        if(txt != "" && txt.toUpperCase() != "DD")
        {    
            if((Number(txt)>12) || (txt=="0"))
            {            
                args.IsValid = false;
                return;        
            }            
            else if(Number(currentYear-3) == Number(txt5.value))
            {
                
              if(Number(currentMonth)> Number(txt))
              {            
                args.IsValid = false;
                return;        
              }
            }else if(Number(currentYear) == Number(txt5.value))
            {
              if(Number(currentMonth)< Number(txt))
              {            
                args.IsValid = false;
                return;        
              }
            }
        }
    }      
    args.IsValid = true;
};

function cvClaimYear_SOS(source, args)
{   
    var txt = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));       
      
    if(!(txt1.value == "0" && txt2.value == "0" && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
        if( (txt != "" || txt.toUpperCase() != "YYYY") )
        {                
        var currentYear = (new Date).getFullYear();        
        if((txt<(currentYear-3)) || ((currentYear)<txt))
            args.IsValid = false;
            return;        
        }
    }      
    args.IsValid = true;
};


function cvReqIncidentsDriver_SOS(source, args)
{   var ddlValue = ValidatorGetValue(source.controltovalidate);
    var txt1 = $get($get(source.controltovalidate).getAttribute("refid"));
    var txt2 = $get($get(source.controltovalidate).getAttribute("refid1"));
    var txt3 = $get($get(source.controltovalidate).getAttribute("refid2"));
    var txt4 = $get($get(source.controltovalidate).getAttribute("refid3"));
       
    if(!((txt1.value == "0" || txt1.value == "") && (txt2.value == "0" || txt2.value == "") && (txt3.value == "0" || txt3.value == "") && (txt4.value == "0" || txt4.value == "")))
    {
        if(ddlValue=='0')
        {        
            args.IsValid = false;
            return;        
        }
    }      
    args.IsValid = true;
};

function cvValidateCreditCardExpireDate(source, args) {
    var txt = $get(source.controltovalidate).value;

    if (txt.length == 4) {
        if (txt.substring(0, 2) > '12') {
            args.IsValid = false;
        }
        else {
            var today = CurrentDateTime();
            var currentmonth = "";
            var month = today.getMonth() + 1;
            if (month < 10)
                currentmonth = today.getFullYear().toString() + '0' + month.toString();
            else
                currentmonth = today.getFullYear().toString() + month.toString();

            var expiremonth = '20' + txt.substring(2) + txt.substring(0, 2);

            if (expiremonth < currentmonth)
                args.IsValid = false;
            else
                args.IsValid = true;
        }
    }
    else {
        args.IsValid = false;
    }
};



function shuffle(items) {
    var cached = items.slice(1), temp, i = cached.length, rand;
    while (--i) {
        rand = Math.floor(i * Math.random());
        temp = cached[rand];
        cached[rand] = cached[i];
        cached[i] = temp;
    }
    return cached;
}
function shuffleNodes(list) {
    if (list == null) {
        return;
    }
    var nodes = list.children, i = 0;
    nodes = Array.prototype.slice.call(nodes);
    nodes = shuffle(nodes);
    while (i < nodes.length) {
        list.appendChild(nodes[i]);
        ++i;
    }
}

function HighlightMisMatchedField(ctlId) {
    $("#" + ctlId).closest("tr").addClass("DataMisMatch");
}

function ResetHighlightMisMatchedField() {
    $(".DataMisMatch").removeClass("DataMisMatch");
}

function confirmPSID(contactId) {
    $("#hfPSContactID").val(contactId);
    top.__HideLB_Frame('');
    $("#btnConfirmed").click();
}
function cancelPSID() {
    $("#btnCanceled").click();
}
function showConfirmPSID() {
    var url = $("#hfPSLogInURL").val();
    setTimeout(function () { __ShowLB_FrameDelay('LIBTitle_ConfirmID', '', "695px", "400px", url); }, 1);
}
function CheckPSID() {
    if ($("#hfPSContactID").val() == '') {
        showConfirmPSID();
        return;
    }
    else {
        $("#btnCanceled").click();
    }
}
function HighlightMisMatchedTDField(ctlId) {
    $("#" + ctlId).closest("td").addClass("DataMisMatch");
}
