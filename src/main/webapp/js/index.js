/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


var history_url = new Array();
var cururl = '';
var counter = 0;
var login_info = {};
var mySwiper;
var datatype = '';
var ajaxformOption = {
    beforeSubmit: function (arr, $form, options) {
        return true;
    },
    success: function (ret, xhr, $form) {
        $("#body").html(ret);
    }
};
$(function () {
    $('.swiper-container').height($(window).innerHeight() - 150);
    var d = new Date();
    var n = d.getDay();
    var ds = d.getFullYear() + "年" + (d.getMonth() + 1) + "月" + d.getDate() + "日";
    $('#weekdaytable td').eq(n).find('a').addClass('today');
    $('#today-weekday').html($('#weekdaytable td').eq(n).find('a').attr('name'));
    $('#today-date').html(ds);
    chg_city(2306179, '台北市');
    parseRSS('https://news.google.com.tw/news?pz=1&cf=all&ned=tw&hl=zh-TW&output=rss', function (feed) {
        $.each(feed.entries, function (k, v) {
            var onenews = '<dt><a href="' + v.link + '" target="_blank">' + v.title + '</a></dt><dd>' + v.contentSnippet.substring(0, 50) + ' ...</dd>';
            $('.news').append(onenews);
        });
    });
    $('#news').perfectScrollbar();
    $('#sec_selt').change(function () {
        var fid = $(this).val();
        var dr = $(this).find('option:selected').attr('dr');
        chg_freeway(fid, dr);
    });
    $('#search-type').change(function () {
        chg_datatype();
    })
    chg_freeway('10010', 'ns');
    get_rooms();
    $('#bulletin').perfectScrollbar();
    $('#rail').perfectScrollbar();
    $('#highrail').perfectScrollbar();
});
function show_ctrl(eptype, devID) {
    if (login_info.loginid)
        return false;
    switch (eptype) {

        case "02": //紅外感應
        case "03":
            var cont = '<div>裝置ID：' + devID + '</div>';
            var btn1 = '<div><br /><button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'0\');">撤防</button>';
            var btn2 = ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\',\'1\');">佈防</button></div>';
            cont = cont + btn1 + btn2;
            var dev_name = eptype == "02" ? "門窗感應裝置" : "紅外感應裝置";
            create_modal(dev_name, cont);
            break;
        case "12": //調光開關
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div class="light-slider-row"><br />';
            cont += '<div style="float:left; width:20%">調光設定：</div>';
            cont += '<div style="float:left; width:70%" id="light-slider" class="light-slider"></div>';
            cont += '</div>';
            create_modal('調光開關控制', cont);
            var light = $('#' + devID).attr('epdata');
            $('.light-slider').slider({
                value: light,
                change: function (event, ui) {
                    var new_light = ui.value;
                    var txt = '';
                    send_ctrl(devID, eptype, new_light);
                    if (new_light == 100) {
                        txt = '全開';
                    } else if (new_light == 0) {
                        txt = '全關';
                    } else {
                        txt = new_light + '%';
                    }
                    alert('已設定至' + txt);
                }
            });
            break;
        case "15": //計量插座
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div><br /><button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'11\');">開</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'10\');">關</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'50\');">查詢</button></div>';
            create_modal('計量插座控制', cont);
            break;

        case "22": //紅外控制
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div><br /><button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2511\');">開 / 關</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2512\');">選台上</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2513\');">選台下</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2514\');">音量大</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2515\');">音量小</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2516\');">1</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2517\');">2</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2518\');">3</button></div>';
            create_modal('紅外轉發控制', cont);
            break;
        case "50": //單鍵插座
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div><br /><button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'1\');">開</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'0\');">關</button></div>';
            create_modal('單鍵插座控制', cont);
            break;
        case "61": //單切
            var chk_status = get_switch_status(devID);
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div id="switcher-' + devID + '"><br />';
            cont += '<label class="checkbox-inline"> <input type="checkbox" ' + chk_status[0] + ' data-toggle="toggle" onchange="send_switch(\'' + devID + '\', \'' + eptype + '\', \'0\');">開關 1 </label></div>';
            create_modal('單切開關', cont);
            $('#switcher-' + devID + ' input:checkbox').bootstrapToggle();
            break;
        case "62": //雙切
            var chk_status = get_switch_status(devID);
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div id="switcher-' + devID + '"><br />';
            cont += '<label class="checkbox-inline"> <input type="checkbox" ' + chk_status[0] + ' data-toggle="toggle" onchange="send_switch(\'' + devID + '\', \'' + eptype + '\', \'0\');">開關 1 </label>';
            cont += '<label class="checkbox-inline"> <input type="checkbox" ' + chk_status[1] + ' data-toggle="toggle" onchange="send_switch(\'' + devID + '\', \'' + eptype + '\', \'1\');">開關 2 </label></div>';
            create_modal('雙切開關', cont);
            $('#switcher-' + devID + ' input:checkbox').bootstrapToggle();
            break;
        case "63": //三切
            var chk_status = get_switch_status(devID);
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div id="switcher-' + devID + '"><br />';
            cont += '<label class="checkbox-inline"> <input type="checkbox" ' + chk_status[0] + ' data-toggle="toggle" onchange="send_switch(\'' + devID + '\', \'' + eptype + '\', \'0\');">開關 1 </label>';
            cont += '<label class="checkbox-inline"> <input type="checkbox" ' + chk_status[1] + ' data-toggle="toggle" onchange="send_switch(\'' + devID + '\', \'' + eptype + '\', \'1\');">開關 2 </label>';
            cont += '<label class="checkbox-inline"> <input type="checkbox" ' + chk_status[2] + ' data-toggle="toggle" onchange="send_switch(\'' + devID + '\', \'' + eptype + '\', \'2\');">開關 3 </label></div>';
            create_modal('三切開關', cont);
            $('#switcher-' + devID + ' input:checkbox').bootstrapToggle();
            break;
        case "65": //curtain controller
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div><br /><button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'1\');">暫停</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'2\');">關</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'3\');">開</button></div>';
            create_modal('窗簾控制', cont);
            break;
        case "70": //4 generation door lock
            var cont = '<div>裝置ID：' + devID + '</div>';
            cont += '<div><br /><button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'11\');">解鎖</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'12\');">上鎖</button>';
            cont += ' &nbsp; <button type="button" class="btn btn-default" onclick="send_ctrl(\'' + devID + '\', \'' + eptype + '\', \'13\');">查詢</button></div>';
            create_modal('門鎖控制', cont);
            break;
        case "crestron":
            var ip = $('#' + devID).attr('ip');
            $('#crestron-window').attr('src', ip);
            $('#crestron-modal').modal('show');
            break;
        case "ipcam":
            switch (devID) {
                case "ipcam1":
                    $("#device_table").toggle(1000);
                    $('#ipcam_div1').toggle(1000);
                    break;
                case "ipcam2":
                    $("#device_table").toggle(1000);
                    $('#ipcam_div2').toggle(1000);
                    break;
            }
            break;
    }
}
function send_ctrl(devID, epType, ctrlcode, keepme) {
    get_data('_includes/devices.php?cmd=control', {devID: devID, epType: epType, ctrlcode: ctrlcode}, function (res) {
        if (!keepme)
            $('#ctrl-modal').modal('hide');
        refresh_devices(true);
    });
}
function send_switch(devID, epType, seq) {
    var ctrlcode = '';
    $('#switcher-' + devID + ' input:checkbox').each(function (i, j) {
        if (i == seq) {
            var stat = $(this).prop('checked') ? '1' : '0';
            ctrlcode += stat;
        } else {
            ctrlcode += '2';
        }
    });
    send_ctrl(devID, epType, ctrlcode, 1);
}
function get_switch_status(devID) {
    var epData = $('#' + devID).attr('epdata');
    var statuses = epData.split("");
    var chk_status = [];
    $.each(statuses, function (k, j) {
        chk_status[k] = j == 'Y' ? 'checked' : '';
    });
    return chk_status;
}
function create_modal(title, cont) {
    $('#ctrl-title').html(title);
    $('#ctrl-content').html(cont);
    $('#ctrl-modal').modal('show');
}
function close_modal() {
    $('#ctrl-modal').modal('hide');
}
function clear_alert(devID, epType) {
    get_data('_includes/devices.php?cmd=clear', {devID: devID, epType: epType}, function (res) {
        close_modal();
    });
}
function chg_location(el, x, y) {
    var devID = el.attr('dev');
    var location = x + ',' + y;
    get_data("_includes/devices.php?cmd=chg_location", {devID: devID, location: location});
}
function get_rooms() {
    $('div.ctl').remove();
    $.get("_includes/devices.php?cmd=get_rooms", function (ret) {
        var data = $.parseJSON(ret);
        $.each(data, function (k, v) {
            var swiper_slider = '<div class="swiper-slide" style="width:100%; overflow:hidden"><div id="layoutrooms_' + v.room_id + '" class="layout" style="width:auto" ><img src="' + v.bg_image + '" style="margin-left:1px;" /></div></div>';

            $('#layout-wrapper').append(swiper_slider);
            var menu = '<li role="presentation"><a onclick="swipeto(' + k + ')">' + v.name + '</a></li>';
            $('#layout-pills').append(menu);
            //$('#layoutrooms_'+v.room_id).perfectScrollbar();
        });
        $('#layout-pills li').eq(0).addClass('active');
        //attach_drag();
        /**/
        mySwiper = $('.swiper-container').swiper({
            mode: 'horizontal',
            loop: false,
            noSwiping: true,
            onSlideChangeEnd: toggle_pills,
            onSwiperCreated: function () {
                attach_drag();
            }
        });

    });
}
function attach_drag() {
    /*
     $(".layout").draggable({drag: function( event, ui ) {
     v_diff=$('.swiper-container').height() - ui.helper[0].offsetHeight;
     h_diff = $('.swiper-container').width() - ui.helper[0].offsetWidth;
     console.log(ui);
     if(ui.position.left > 0){
     ui.position.left = 0;
     }else if(ui.position.left < h_diff){
     ui.position.left = h_diff;
     }
     if(ui.position.top > 0){
     ui.position.top = 0;
     }else if(ui.position.top <  v_diff){
     ui.position.top =v_diff;
     }
     }});*/
    refresh_devices();
}
function toggle_pills() {
    var index = mySwiper.activeIndex;
    $('#layout-pills li').removeClass('active');
    $('#layout-pills li').eq(index).addClass('active');
}
function refresh_devices(once) {
    counter++;
    $('#refresh_counter').html(counter);
    $.get("_includes/devices.php?cmd=get", function (ret) {
        var data = $.parseJSON(ret);
        $.each(data, function (k, v) {
            if (v.type == 'areas') {

            } else if (v.type == 'image') {

            } else if (v.type == 'device') {
                if ($('div[dev="' + v.devID + '"]').length > 0) {
                    //if(v.html) $('div[dev="'+v.devID+'"] ul li').html(v.html);
                    $('div[dev="' + v.devID + '"]').remove();
                }
                var htm = '<div id="' + v.devID + '" eptype="' + v.epType + '" dev="' + v.devID
                        + '" ip="' + v.ip + '" epdata="' + v.epData
                        + '" class="ctl ' + v.status + '"><div><i class="fa fa-fw ' + v.icon + '"></i></div>';

                if (v.html)
                    htm += '<ul><li>' + v.html + '</li></ul>';
                htm += '</div>';
                if ($.isArray(v.rooms)) {
                    $.each(v.rooms, function (j, u) {
                        var roomid = 'layoutrooms_' + u.room_id;
                        $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('#' + roomid).click(function () {
                            show_ctrl(v.epType, v.devID);
                        });
                    });
                }
                if (v.alert == '1') { //告警
                    var cont = '<h3><span  class="entypo-alert"></span > 告警訊息！！</h3>';
                    cont += '<div>裝置名稱:' + v.name + '<br />裝置ID:' + v.devID + '</div>';
                    cont += '<div><br />';
                    cont += '<button type="button" class="btn btn-default" onclick="send_ctrl(\'' + v.devID + '\', \'' + v.eptype + '\', \'0\');">撤防</button>&nbsp;';
                    cont += '<button type="button" class="btn btn-default" onclick="clear_alert(\'' + v.devID + '\', \'' + v.eptype + '\');">知道了，維持佈防</button>&nbsp;';
                    cont += '</div>';
                    create_modal('告警通知', cont);
                }
            }
            if (v.datatype && $('#all-devID option[value="' + v.devID + '"]').length <= 0) {
                var opt = '<option datatype="' + v.datatype + '" value="' + v.devID + '">' + v.devID + '</option>';
                $('#all-devID').append(opt);
            }
        });
        if (!datatype)
            chg_datatype();
        if (!once)
            setTimeout(refresh_devices, 1000);
    });
}
function chg_datatype() {
    datatype = $('#search-type').val();
    $('#search-devID option:gt(0)').remove();
    $('#search-devID option:eq(0)').prop('selected', true);
    $('#all-devID option[datatype="' + datatype + '"]').clone().appendTo('#search-devID');
}
function chg_freeway(fid, dr) {
    $('#traffics_table tbody').html('<tr class="reading"><td colspan="3"><div class="text-center" style="height:250px">讀取中...</div></td>');
    if (dr == 'ew') {
        $('#dr-s').html('東向');
        $('#dr-n').html('西向');
    } else {
        $('#dr-s').html('南向');
        $('#dr-n').html('北向');
    }
    try {
        $.get("_includes/traffic.php?fid=" + fid, function (ret) {
            var row = '';
            var data = $.parseJSON(ret);
            $.each(data, function (k, v) {
                row += '<tr><td>' + v.sec_name + '</td><td>' + v.speed_left + '</td><td>' + v.speed_right + '</td></tr>';
            });
            $('#traffics_table tbody').html(row);
            $('#traffics').perfectScrollbar();
        });
    } catch (e) {
        alert('交通資訊暫時無法取得！');
        console.log(e);
    }
}
function chg_city(id, city) {
    $('#weatherReport').weatherfeed([id], {
        woeid: true,
        forecast: true,
        link: true,
        linktarget: '_self',
        highlow: false
    }, function () {
        var cities = [['基隆市', 2306188], ['台北市', 2306179], ['新北市', 90717580], ['桃園縣', 91290407], ['新竹市', 2306185], ['新竹縣', 2347334], ['苗栗縣', 2347338], ['台中市', 2306181], ['彰化縣', 20070572], ['雲林縣', 2347346], ['嘉義縣', 7153409], ['南投縣', 2347339], ['台南市', 2306182], ['高雄市', 2306180], ['屏東縣', 2347340], ['宜蘭縣', 2347336], ['花蓮縣', 2347335], ['台東縣', 91290354]];
        var str = '<span>' + city + '</span><i class="fa fa-sort"></i><ul>';
        $.each(cities, function (k, v) {
            str += "<li><a onclick=\"chg_city('" + v[1] + "', '" + v[0] + "')\">" + v[0] + "</a></li>";
        });
        str += '</ul>';
        $('.weatherCity').html(str).click(function () {
            $('.weatherCity ul').toggle();
        });
        $('.weatherCity ul').hide();
    });
}
function showLogin() {
    if (login_info.loginid) {
        login_info = {};
        $('#login-icon').removeClass('fa-sign-out').addClass('fa-cog');
        alert('已登出');
        $('#layout-elements').addClass('hidden');
        $('.ctl').draggable('destroy')
    } else {
        $('#login-modal').modal('show');
    }
}
function doLogin() {
    var loginid = $('input[name="loginid"]').val();
    a
    var passwd = $('input[name="passwd"]').val();
    if (loginid.length <= 0 || passwd.length <= 0) {
        alert('請輸入帳號及密碼');
        return;
    }
    login_info = {loginid: loginid, passwd: passwd};
    $('#login-icon').removeClass('fa-cog').addClass('fa-sign-out');
    $('#layout-img .ctl').draggable({containment: "parent"});
    $('#layout-elements .ctl').draggable({revert: true});
    $('#layout-elements').removeClass('hidden');
}
function set_crestron() {
    var ip = $('#crestron-ip').val();
    var name = $('#crestron-name').val();
    get_data('_includes/devices.php?cmd=add_crestron', {ip: ip, name: name}, function (res) {
        $('#add-crestron-modal').modal('hide');
        refresh_devices(true);
    });
}
function swipeto(i) {
    mySwiper.swipeTo(i);
    /*
     $('#layout-wrapper .swiper-slide').fadeOut();
     $('#layout-wrapper .swiper-slide:eq('+i+')').fadeIn();
     */
}
function parseRSS(url, callback) {
    $.ajax({
        url: document.location.protocol + '//ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=10&callback=?&q=' + encodeURIComponent(url),
        dataType: 'json',
        success: function (data) {
            callback(data.responseData.feed);
        }
    });
}
function load_page(url) {
    if (history_url.length >= 10)
        history_url.shift();
    history_url.push(url);
    if (history_url.length > 1)
        $("#go_prev").show();
    location.href = url;
}
function reload_page() {
    if (cururl.length > 0)
        load_page(cururl);
}
function prev_page() {
    if (history_url.length > 1) {
        var cur_url = history_url.pop();
        var prev_url = history_url.pop();
        load_page(prev_url);
    }
}
function set_var(selector, value) {
    $(selector).val(value);
    return true;
}
function register_form(frm, func_callback, func_before) {
    $(frm).ajaxForm({
        beforeSubmit: func_before,
        success: function (ret) {
            proc_ret(ret, func_callback);
        }
    });
}
function submit_form(frm, func_callback, func_before) {
    $(frm).ajaxSubmit({
        beforeSubmit: func_before,
        success: function (ret) {
            proc_ret(ret, func_callback);
        }
    });
}
function get_data(url, send_data, proc_handler) {
    $.ajax({
        url: url,
        type: 'post',
        data: send_data,
        success: function (ret) {
            proc_ret(ret, proc_handler);
        }
    });
}
function proc_ret(ret, proc_handler) {
    try {
        res = $.parseJSON(ret);
        if (typeof (proc_handler) == 'function')
            proc_handler(res);
    } catch (e) {
        console.log(e);
        msgbox_show('系統錯誤，可能是連線中斷，請稍候再試！');
        console.log(ret);
    }
}
function msgbox_show(msg, alertDismissed) {
    alert(msg);
    if (alertDismissed)
        alertDismissed;
}