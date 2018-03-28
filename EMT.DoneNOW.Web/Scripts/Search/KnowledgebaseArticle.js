$('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="Management()">知识库管理</li>');
function Add() {
    //OpenWindow("../ServiceDesk/AddRepository.aspx", windowType.blank, 'left=0,top=0,location=no,status=no,width=800,height=700', false);
    window.open("../ServiceDesk/AddRepository.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=800,height=700");
}
function Edit() {
    //OpenWindow("../ServiceDesk/AddRepository.aspx", windowType.blank, 'left=0,top=0,location=no,status=no,width=800,height=700', false);
    window.open("../ServiceDesk/EditRepository.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=800,height=700");
}
function Management() {
    window.open("../ServiceDesk/ManageKnowledgebase.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=*,height=*");
}

function View() {
    window.open("../ServiceDesk/KnowledgebaseDetail.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=*,height=*");
}
function DeleteServiceBundle() {
    
    var r = confirm("删除无法恢复，你想继续吗？");
    if (r == true) {
        //    alert("You pressed OK!");
    }
    else {
        // alert("You pressed Cancel!");
    }
}