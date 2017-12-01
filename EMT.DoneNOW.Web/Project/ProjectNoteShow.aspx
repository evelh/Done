<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectNoteShow.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectNoteShow" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div>
            </div>
            <iframe runat="server"></iframe>
            <input type="hidden" id="note_id" />
        </div>
        <div>
            <div class="NoteSection">
                <table align="center" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="100" class="FieldLabels">
                                <nobr>Note Title:</nobr>
                            </td>
                            <td width="25%" colspan="5" class="NotePrintRowText" nowrap="">&nbsp;Project Baseline Created.</td>
                            <td align="right" valign="middle" width="10%" rowspan="2">
                                <div class="contentButton">
                                    <script type="text/javascript">btnPrint.draw();</script>
                                    <a class="OnlyImageButton" id="HREF_btnPrint" name="HREF_btnPrint" href="javascript:btnPrint.punch(true);">
                                        <img title="Print" onmouseout="btnPrint.normal();" name="IMG_btnPrint" src="https://ww6.autotask.net/graphics/icons/buttonbar/print.png?v=41661" border="0"></a></div>
                            </td>
                        </tr>
                        <tr>
                            <td width="100" class="FieldLabels">
                                <nobr>Created By:</nobr>
                            </td>
                            <td width="25%" class="NotePrintRowText">&nbsp;li, li</td>
                            <td width="15%" align="right" class="FieldLabels">Note Type:</td>
                            <td width="20%" class="NotePrintRowText">&nbsp;Project Notes</td>
                            <td width="15%" align="right" class="FieldLabels">Create Date: </td>
                            <td width="20%" class="NotePrintRowText">&nbsp;13/11/2017</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div>
            <table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left:10px;margin-top:10px;;padding-right: 10px; padding-left: 10px;">
	<tbody><tr>
		<td>
			<!-- inner table for formatting -->
			<table border="0" cellspacing="0" cellpadding="">
				<tbody><tr><td colspan="3" align="left" class="FieldLabels" style="white-space:nowrap;">Note Attachments</td></tr><tr>
						<td align="center" style="padding-left:10px;padding-top:10px;width:50px; vertical-align:top;">
							<a target="_new" href="/autotask/StreamAttachment.aspx?objectID=98"><img src="/graphics/icons/content/attachment.png?v=41661" title="8c1001e93901213fcf8e7f2e56e736d12e2e9586"><br>8c1001e93901213fcf8e7f2e56e736d12e2e9586</a>
						</td>
						
						<td align="center" style="padding-left:10px;padding-top:10px;width:50px; vertical-align:top;">
							<a target="_new" href="/autotask/StreamAttachment.aspx?objectID=99"><img src="/graphics/icons/content/attachment.png?v=41661" title="8c1001e93901213fcf8e7f2e56e736d12e2e9586"><br>8c1001e93901213fcf8e7f2e56e736d12e2e9586</a>
						</td>
						
						<td align="center" style="padding-left:10px;padding-top:10px;width:50px; vertical-align:top;">
							<a target="_new" href="/autotask/StreamAttachment.aspx?objectID=100"><img src="/graphics/icons/content/attachment.png?v=41661" title="appendix"><br>appendix</a>
						</td>
						
						<td align="center" style="padding-left:10px;padding-top:10px;width:50px; vertical-align:top;">
							<a target="_new" href="/autotask/StreamAttachment.aspx?objectID=101"><img src="/graphics/icons/content/attachment.png?v=41661" title="8c1001e93901213fcf8e7f2e56e736d12e2e9586"><br>8c1001e93901213fcf8e7f2e56e736d12e2e9586</a>
						</td>
						</tr>
			</tbody></table>
			<!-- inner table for formatting -->
		</td>
	</tr>	
	<tr>
		<td id="txtBlack8"><br />
			1
		</td>
	</tr>							
</tbody></table>
        </div>
    </form>
</body>
</html>
