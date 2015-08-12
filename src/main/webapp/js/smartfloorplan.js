/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(function () {

    $('div').find('img[name="roomimg"]').each(function () {
        var imgClass = (this.width / this.height > 1) ? 'wide' : 'tall';
        $(this).addClass(imgClass);
    });
    $('a[name="floorNav-1"]').parent('li').addClass("active");

    setTimeout(refresh_devices(), 1000);

});
/*
 var mySwiper = new Swiper('.swiper-container', {
 // Optional parameters
 direction: 'horizontal',
 speed: 500,
 //control
 mousewheelControl: true,
 loop: true,
 //Grab Cursor
 grabCursor: true,
 //Touches
 threshold: 10,
 // Navigation arrows                          
 nextButton: '.swiper-button-next',
 prevButton: '.swiper-button-prev',
 // And if we need scrollbar
 scrollbar: '.swiper-scrollbar'
 });
 */
var swiperH = new Swiper('.swiper-container-h', {
    pagination: '.swiper-pagination-h',
    paginationClickable: true,
    paginationBulletRender: function (index, className) {
        return '<span class="' + className + '">' + (index + 1) + '</span>';
    },
    spaceBetween: 50
});
var swiperV = new Swiper('.swiper-container-v', {
    pagination: '.swiper-pagination-v',
    paginationClickable: true,
    paginationBulletRender: function (index, className) {
        return '<span class="' + className + '">' + (index + 1) + 'F</span>';
    },
    direction: 'vertical',
    spaceBetween: 50,
    nextButton: '.swiper-button-next',
    prevButton: '.swiper-button-prev'
});

$('a[name*="floorNav"]').click(function () {
    var floor_id = parseInt(this.name.split("-")[1]) - 1;//int 1 or 11
    swiperV.slideTo(floor_id, 1000, true);
    //swiperH.slideTo(0, 1000, true);
    //remove active and make parant li active
    $('li[class|="active"]').removeClass("active");
    $(this).parent('li').addClass("active");
});
$('a[name*="roomNav"]').click(function () {
    var roomId = this.name.split("-")[1]; //string 105
    var idInFloor = parseInt(roomId.slice(-2)); //int 5
    swiperH.slideTo(idInFloor, 1000, true);
    //remove active and make parant li active
    $('li[class|="active"]').removeClass("active");
    $(this).parent('li').addClass("active");
});
function SwipeToRoom(roomId) {
    //remove active and make parant li active
    var intRoomId = parseInt(roomId.toString().slice(-2)); //1
    $('li[class|="active"]').removeClass("active");
    $('ul li:nth-child(' + (intRoomId + 1) + ')').addClass("active");
    swiperH.slideTo(intRoomId);
}

swiperH.on('slideChangeStart', function (swiper) {
    console.log(swiper.activeIndex);
    $('li[class|="active"]').removeClass("active");
    $('ul li:nth-child(' + (swiper.activeIndex + 1) + ')').addClass("active");
});


function refresh_devices(once) {
    /*
     counter++;
     $('#refresh_counter').html(counter);
     
     $.get("_includes/devices.php?cmd=get", function (ret) {
     */

    $.getJSON("devices.json", function (data) {
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
                //append htm to div
                if ($.isArray(v.rooms)) {
                    $.each(v.rooms, function (j, u) {
                        $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('div#floor' + u.room_id);
                        /*
                         * var roomid = 'layoutrooms_' + u.room_id;
                         $(htm).addClass('ico-mode').css({position: "absolute", top: u.y + 'px', left: u.x + 'px'}).appendTo('#' + roomid).click(function () {
                         show_ctrl(v.epType, v.devID);
                         });
                         */
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
    });
}