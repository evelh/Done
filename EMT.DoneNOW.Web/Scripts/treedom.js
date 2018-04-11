 function getStyle(el, attr) {
     return getComputedStyle(el)[attr];
 }
 //var data = [{
 //    text: "家用电器",
 //    child: [{
 //        text: "电视",
 //        child: [{
 //            text: "曲面电视",
 //            child: [{
 //                    text: "4k屏"
 //                },
 //                {
 //                    text: "1080P"
 //                }
 //            ]
 //        }, {
 //            text: "超薄电视"
 //        }]
 //    }, {
 //        text: "空调",
 //        child: [{
 //            text: "壁挂式空调"
 //        }, {
 //            text: "柜式空调"
 //        }, {
 //            text: "中央空调"
 //        }]
 //    }, {
 //        text: "洗衣机"
 //    }, {
 //        text: "冰箱"
 //    }, {
 //        text: "进口电器"
 //    }]
 //}];
 (function () {
     var list = document.createElement("ul");
     list.classList.add('treeul');
     create(list, data);
     var Tree = document.getElementById('Tree');
     Tree.appendChild(list);
     addEv();

     function create(list, data) { //传入ul和数组
         for (var i = 0; i < data.length; i++) { //循环数组长度生成li和内容
             var li = document.createElement("li");
             li.classList.add('treeli');             
             var p = document.createElement("p");
             p.classList.add('treep');                     
             p.innerHTML = data[i].name + "&nbsp;&nbsp;<a onclick='Edit(\'" + data[i].id + "\')'>编辑</a>&nbsp;&nbsp;<a onclick='Delete(\'" + data[i].id + "\')'>删除</a>&nbsp;&nbsp;<a onclick='AddSub(\'" + data[i].id + "\')'>新增子目录</a>";
             
             li.appendChild(p);
             console.log(p.firstChild)
             if (data[i].nodes) { //如果还有子项
                 var ul = document.createElement("ul"); //生成ul
                 create(ul, data[i].nodes); //传入ul，以及子项的数组，生成子项的li
                 li.appendChild(ul);
                 p.innerHTML = "<span><img src = '../Images/imgMinus.gif'></span>" + data[i].name + "&nbsp;&nbsp;<a onclick='Edit(\"" + data[i].id + "\")'>编辑</a>&nbsp;&nbsp;<a  onclick='Delete(\"" + data[i].id + "\")'>删除</a>&nbsp;&nbsp;<a  onclick='AddSub(\"" + data[i].id + "\")'>新增子目录</a>";
             }
             list.appendChild(li);
         }
     }
 })();
 function addEv() {
     var span = document.querySelectorAll('span');
     for (var i = 0; i < span.length; i++) {
         span[i].onclick = function () {
             var ul = this.parentNode.nextElementSibling; /*获取它下边的ul */
             if (ul) { /*存在*/
                 var uls = this.parentNode.parentNode.parentNode.getElementsByTagName("ul");
                 for (var i = 0; i < uls.length; i++) {
                    //  if (uls[i] != ul) {
                    //      uls[i].style.display = "none"; //清除掉同级所有ul(排除当前个)
                    //  }
                 }
                 /* 操作当前个 */
                 if (getStyle(ul, "display") == "none") {
                     ul.style.display = "block";
                     this.innerHTML = "<img src = '../Images/imgMinus.gif'>";
                 } else {
                     ul.style.display = "none";
                     this.innerHTML = "<img src = '../Images/imgPlus.gif'>";                     
                 }
             }
         }
     }
 }


