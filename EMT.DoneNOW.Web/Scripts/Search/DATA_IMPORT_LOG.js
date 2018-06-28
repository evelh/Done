
//$('.contenttitle ul').html('<li onclick="ImportData()"><i style= "background: url(/Images/ButtonBarIcons.png) no-repeat -208px -32px;" class="icon-1" ></i ><input type="button" value="导入"></li>');

function View(id) {
    window.location.href = "SearchBodyFrame.aspx?cat=1790&type=400&con5056=" + id;
}

function Add() {
    window.open('../SysSetting/ImportCompany.aspx?cate=' + $("#param1").val(), windowObj.dataImport + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
