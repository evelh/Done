﻿/*!
 * jquery.dad.js v1 (http://konsolestudio.com/dad)
 * Author William Lima
 */
(function ($) {
    "use strict";

    function O_dad() {
        var self = this;
        this.x = 0;
        this.y = 0;
        this.target = false;
        this.clone = false;
        this.placeholder = false;
        this.cloneoffset = {
            x: 0,
            y: 0
        };
        this.move = function (e) {
            self.x = e.pageX;
            self.y = e.pageY;
            if (self.clone != false && self.target != false) {
                self.clone.css({
                    'margin-left': self.target.css('marginLeft'),
                })
                var parent_wh = self.target.parent().width() - self.target.width();
                if (self.x - self.cloneoffset.x <= 10) {
                    return;

                } else
                    if (self.x - self.cloneoffset.x > parent_wh) {
                        return;

                    } else {
                        self.clone.css({
                            left: self.x - self.cloneoffset.x,
                        })
                    }
            } else { }
        };
        $(window).on('mousemove', function (e) {
            self.move(e)
        })
    }
    $.prototype.dad2 = function (opts) {
        var me, defaults, options;
            var downtime = 0;var fun ;
        var hasMoveT;
        me = this;
        defaults = {
            target: '>div',
            draggable: false,
            placeholder: '',
            callback: false,
            containerClass: 'dad-container2',
            childrenClass: 'dads-children2',
            cloneClass: 'dads-children-clone2',
            active: true
        };
        options = $.extend({}, defaults, opts);
        $(this).each(function () {
            var mouse, target, dragClass, active, callback, placeholder, daddy, childrenClass, jQclass, cloneClass;
            mouse = new O_dad();
            active = options.active;
            daddy = $(this);
            if (!daddy.hasClass('dad-active') && active == true) daddy.addClass('dad-active');
            childrenClass = options.childrenClass;
            cloneClass = options.cloneClass;
            jQclass = '.' + childrenClass;
            daddy.addClass(options.containerClass);
            target = daddy.find(options.target);
            placeholder = options.placeholder;
            callback = options.callback;
            dragClass = 'dad-draggable-area';
            me.addDropzone = function (selector, func) {
                $(selector).on('mouseenter', function () {                    
                    if (mouse.target != false) {
                        mouse.placeholder.css({
                            display: 'none'
                        });
                        mouse.target.css({
                            display: 'none'
                        });
                        $(this).addClass('active')
                    }
                }).on('mouseup', function () {
                    if (mouse.target != false) {
                        mouse.placeholder.css({
                            display: 'block'
                        });
                        mouse.target.css({
                            display: 'block'
                        });
                        func(mouse.target);
                        dad_end()
                    }
                    $(this).removeClass('active')
                }).on('mouseleave', function () {
                    if (mouse.target != false) {
                        mouse.placeholder.css({
                            display: 'block'
                        });
                        mouse.target.css({
                            display: 'block'
                        })
                    }
                    $(this).removeClass('active')
                })
            };
            me.getPosition = function () {
                var positionArray = [];
                $(this).find(jQclass).each(function () {
                    positionArray[$(this).attr('data-dad-id')] = parseInt($(this).attr('data-dad-position'))
                });
                return positionArray
            };
            me.activate = function () {
                active = true;
                if (!daddy.hasClass('dad-active')) {
                    daddy.addClass('dad-active')
                }
                return me
            };
            me.deactivate = function () {
                active = false;
                daddy.removeClass('dad-active');
                return me
            };
            $(document).on('mouseup', function () {
                clearInterval(hasMoveT)
                dad_end()
                console.log(downtime)
                downtime = 0;       
            });
            var order = 1;
            target.addClass(childrenClass).each(function () {
                if ($(this).data('dad-id') == undefined) {
                    $(this).attr('data-dad-id', order)
                }
                $(this).attr('data-dad-position', order);
                order++
            });

            function update_position(e) {
                var order = 1;
                e.find(jQclass).each(function () {
                    $(this).attr('data-dad-position', order);
                    order++
                })
            }

            function dad_end() {
                
                if (mouse.target != false && mouse.clone != false) {
                    if (callback != false) {
                        callback(mouse.target)
                    }
                    var appear = mouse.target;
                    var desapear = mouse.clone;
                    var holder = mouse.placeholder;
                    var bLeft = 0;
                    Math.floor(parseFloat(daddy.css('border-left-width')));
                    var bTop = 0;
                    Math.floor(parseFloat(daddy.css('border-top-width')));
                    if ($.contains(daddy[0], mouse.target[0])) {
                        mouse.clone.animate({
                            top: mouse.target.offset().top - daddy.offset().top - bTop,
                            left: mouse.target.offset().left - daddy.offset().left - bLeft,
                           'margin-left':mouse.target.css('marginLeft')                          
                        }, 0, function () {
                            appear.css({
                                visibility: 'visible'
                            }).removeClass('active');
                            desapear.remove()
                        })
                    } else {
                        mouse.clone.fadeOut(0, function () {
                            desapear.remove()
                        })
                    }
                    holder.remove();
                    mouse.clone = false;
                    mouse.placeholder = false;
                    mouse.target = false;
                    update_position(daddy)
                }
                $("html,body").removeClass('dad-noSelect')
            }

            function dad_update(obj) {
                if (mouse.target != false && mouse.clone != false) {
                    var newplace, origin;
                    origin = $('<span style="display:none"></span>');
                    newplace = $('<span style="display:none"></span>');
                    if (obj.prevAll().hasClass('active')) {
                        obj.after(newplace)
                    } else {
                        obj.before(newplace)
                    }
                    mouse.target.before(origin);
                    newplace.before(mouse.target);
                    mouse.placeholder.css({
                        top: mouse.target.offset().top - daddy.offset().top,
                        left: mouse.target.offset().left - daddy.offset().left,
                        width: mouse.target.outerWidth() ,
                        height: mouse.target.outerHeight() ,
                        opacity:0,
                        
                        'margin-left':mouse.target.css('marginLeft')                            
                        
                    });
                    origin.remove();
                    newplace.remove()
                }
            }
            var jq = (options.draggable != false) ? options.draggable : jQclass;
            daddy.find(jq).addClass(dragClass);

            daddy.find(jq).on('mousedown touchstart', function (e) {
                    if (mouse.target == false && e.which == 1 && active == true) {
                        if (options.draggable != false) {
                            mouse.target = daddy.find(jQclass).has(this)
                        } else {
                            mouse.target = $(this)
                        }
                        
                        fun = function(){
                            // console.log(hasMoveT)
                             downtime++;        
                             if(downtime==2){
                                clearInterval(hasMoveT)
                                mouse.clone = mouse.target.clone();
                                mouse.target.css({
                                    visibility: 'hidden',
                                }).addClass('active');
                                mouse.clone.addClass(cloneClass);
                                daddy.append(mouse.clone);
                                mouse.placeholder = $('<div></div>');
                                mouse.placeholder.addClass('dads-children-placeholder2');
                                mouse.placeholder.css({
                                    // top: mouse.target.offset().top - daddy.offset().top,
                                    // left: mouse.target.offset().left - daddy.offset().left,
                                    // width: mouse.target.outerWidth(),
                                    // height: mouse.target.outerHeight(),
                                    // 'margin-left': mouse.target.css('marginLeft'),
                                    // lineHeight: mouse.target.height() + 'px',
                                    // textAlign: 'center',
                                    opacity:0,                        
                                }).text(placeholder);
                                daddy.append(mouse.placeholder);
                                var difx, dify;
                                var bLeft = Math.floor(parseFloat(daddy.css('border-left-width')));
                                var bTop = Math.floor(parseFloat(daddy.css('border-top-width')));
                                difx = mouse.x - mouse.target.offset().left + daddy.offset().left + bLeft;
                                dify = mouse.y - mouse.target.offset().top + daddy.offset().top + bTop;
                                mouse.cloneoffset.x = difx;
                                mouse.cloneoffset.y = dify;
                                mouse.clone.removeClass(childrenClass).css({
                                    position: 'absolute',
                                    top: mouse.y - mouse.cloneoffset.y,
                                    left: mouse.x - mouse.cloneoffset.x,
                                    'margin-left': 0,   
                                });
                                $("html,body").addClass('dad-noSelect')
                            }else{
                              
                                $("html,body").addClass('dad-noSelect')
                            }           
                        }
                        hasMoveT = setInterval(fun,100)                            
                }
            });
            $(jQclass).on('mouseenter', function () {
                dad_update($(this))
            })
        });
        return this
    }
}(jQuery));















