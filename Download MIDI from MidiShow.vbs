'On Error Resume Next

test_connect

'�������⼯SS
'���䣺c141028@protonmail.com
'@TODO������ MidiShow���/MidiShow��ַ/MIDI���� ���¼����MidiShow�ϵ�MIDI��
'@Param: 
'���ڣ�2017/05/22
'ϵͳ��WinXP���ã�Win7+��Vistaδ����
'ע�⣺
'	1. ���ڽű�����GET���ݲ�������д����̣�ĳ���ɱ������϶��ᱨ����
'	   ��˲��ÿ�Դ��ʽ(��������ר�ŵ��������Ϊexe)��
'	2. ���¼���ػ���MidiShow�ķ���Ȩ��©���������˾���֪�������©�����޸���ű����ϡ�
'	3. ���ű�����ѧϰ������ʹ�ã����غ�����24Сʱ��ɾ����
'   4. ���ű�����MITЭ�鿪��Դ���룬������MITЭ���Լ��������ǰ���£��������ɴ������޸ģ�
'
'	MIT License
'
'	Copyright (c) 2016 - 2017 Ji Jie
'
'	Permission is hereby granted, free of charge, to any person obtaining a copy
'	of this software and associated documentation files (the "Software"), to deal
'	in the Software without restriction, including without limitation the rights
'	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
'	copies of the Software, and to permit persons to whom the Software is
'	furnished to do so, subject to the following conditions:
'
'	The above copyright notice and this permission notice shall be included in all
'	copies or substantial portions of the Software.
'
'	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
'	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
'	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
'	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
'	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
'	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
'	SOFTWARE.
'
'	Thanks for using this vbscript script file. =)

Function download(midid,ff)
	Dim url
	Const Ms = "Msxml2.ServerXMLHTTP"
	Const Ad = "Adodb.Stream"
	If ff <> vbNullString Then
		url = Replace(Replace(midid,"/midi/","/midi/file/"),".html",".mid")
		midid = Replace(Split(url,"/")(UBound(Split(url,"/"))),".mid","")
	Else
		If isNumeric(midid) Then
			url = "http://www.midishow.com/midi/file/" & midid & ".mid"
		Else
			Dim Reg
			Set Reg = new RegExp
			Reg.Pattern = "[A-Za-z]+://www.midishow.com/midi/[^/s]+"
			Reg.IgnoreCase = True
			If Reg.Test(midid) = True Then
				url = Replace(Replace(midid,"/midi/","/midi/file/"),".html",".mid")
				midid = Replace(Split(url,"/")(UBound(Split(url,"/"))),".mid","")
			Else
				If midid <> vbNullString Then Search midid
				WScript.Quit()
			End If
		End If
	End If
	Const adTypeBinary = 1
	Const adSaveCreateOverWrite = 2
	Dim http,ado,fn
	Set http = CreateObject(Ms)
	http.open "GET",url,False
	http.send()
	Set ado = createobject(Ad)
	fn = name(Replace(Replace(Replace(url,".mid",".html"),"/file/","/"),"htmli","midi")) & " - " & midid & ".mid"
	Dim oHtml, oWindow, nId
	Set oHtml = CreateObject("htmlfile")
	Set oWindow = oHtml.parentWindow
	ado.Type = adTypeBinary
	ado.Open()
	ado.Write http.responseBody
	ado.SaveToFile fn
	ado.Close()
	nId = oWindow.setTimeout(GetRef("on_timeout"), 2000, "VBScript")
	MsgBox "Download Finished. Midi Saved to: " & fn, 32+4, "MidiShow MIDI���ؽű� By �⼯SS"
	oWindow.clearTimeout nId
End Function

Sub on_timeout()
    CreateObject("WScript.Shell").SendKeys "{Enter}"
End Sub

Function name(path)
	Set http = CreateObject("Msxml2.ServerXMLHTTP")
	http.open "GET",path,False
	http.send()
	nm = Split(Split(http.responseText,"title>")(1)," - MIDI")(0)
	if nm = "MidiShow" Then
		name = "��Midi�����ڡ�"
	Else
		name = nm
	End If
End Function

Function Search(text)
    On Error Resume Next
	Set http = CreateObject("Msxml2.ServerXMLHTTP")
	http.open "GET","http://www.midishow.com/search/midi?title=" & text & "&search=����",False
	http.send
	Dim hrt
	hrt = http.responseText
	If Err Then MsgBox Err.Description, vbCritical + VbMsgBoxSetForeground, "MidiShow MIDI���ؽű� - Error �����ˣ�"
	On Error Goto 0
	If UBound(Split(hrt,"<span class=" & Chr(34) & "empty" & Chr(34) & ">û���ҵ�����.</span>")) <> 0 Then
		MsgBox "û���������������MIDI���ơ�", vbOkCancel + vbInformation, "MidiShow MIDI���ؽű� By �⼯SS"
		WScript.Quit()
	Else
		Ahtml = Split(hrt,"<a target=" & Chr(34) & "ms_p" & Chr(34) & " href=")
		If UBound(Ahtml) <> 0 Then
			morew = vbCrlf & vbCrlf & "��������(�⼯SS)���õ��ԣ���������ֻ����ʾǰ 20 ��" & vbCrlf & "�����������"
			For i = 1 To UBound(Ahtml)
				inner = Split(Ahtml(i),"</a></h3>" & vbCrlf & "	<div class=" & Chr(34) & "c" & Chr(34) & ">")
				out = Split(Replace(inner(0),Chr(34),""),">")
				all = Replace(Replace(Split(Split(Split(hrt,"<div class=" & Chr(34) & "summary" & Chr(34) &">")(1),"</div>")(0),"��")(1),"��.","")," ","")
				star = Replace(Mid(Split(inner(1),"small><button class=" & Chr(34) & "ranks star_")(1),1,2),Chr(34),"")
				d = Split(inner(1),"<br />")(0)
				If d = vbCrlf & "	" Then d = vbCrlf & "�������̫����û�������κ�������_��"
				d = "------------------" & vbCrlf & d & vbCrlf & vbCrlf & "------------------"
				desc = Split(d & vbCrlf & vbCrlf & Split(Replace(Split(inner(1),"</button>&nbsp;&nbsp;-&nbsp;&nbsp;")(1),"&nbsp;&nbsp;-&nbsp;&nbsp;","  "),"</small>")(0),"��ǩ��")(0) & vbCrlf
				If MsgBox("�Ƿ�����MIDI ��" & out(1) & "�� ?" & vbCrlf & vbCrlf & "����������" & vbCrlf & Replace(desc,":","��") & "MIDI�Ǽ��� " & star & "��" & vbCrlf & vbCrlf & "�� " & i & " ������ " & all & " ����" & morew, 32+4,"MidiShow MIDI�޻������� - Confirm") = 6 Then download "http://www.midishow.com" & out(0),out(1)
			Next
		Else
			error = "Error at line 125: " & vbCrlf & "    ��ȡ�����������HTML�Ȳ���˵����û��������MIDI����Ҳ����˵������������MIDI����"
			If MsgBox(error & vbCrlf & "���ܵ�ԭ���У�" & vbCrlf & "    1��MidiShow��վ������İ棬��������ʧ�ܻ��޷�������ҳ��" & vbCrlf & "    2������̫������ӳ�ʱ��" & vbCrlf & vbCrlf & "������ԣ��뷢�ʹ˱��浽 c141028@163.com ��" & vbCrlf & "�����ȷ���������Ʊ���...(����TextBox���������ʧ�ܡ�)", vbOkCancel + vbInformation, "MidiShow MIDI���ؽű� By �⼯SS - Bug Report") = 1 Then copy hrt, True, False
		End If
	End If
End Function

Dim input
input = InputBox("���� MidiShow MIDI��� ��" & vbCrlf & "MidiShow��ַ ��" & vbCrlf & "MIDI ���ƣ�" & vbCrlf & vbCrlf & "�������䣺c141028@protonmail.com" & vbCrlf & "��ӭ�����Ὠ��^_^","MidiShow MIDI��������ؽű� By �⼯SS")
If input <> "" Then download input, vbNullString

Function copy(txt,mtl,alt)
	'Only availiable on WinXP
	If mtl <> True Then If mtl <> False Then mtl = True
	If alt <> True Then If alt <> False Then alt = False
	Dim Form, TextBox
	Set Form = CreateObject("Forms.Form.1")
	Set TextBox = Form.Controls.Add("Forms.TextBox.1").Object
	TextBox.MultiLine = mtl
	TextBox.Text = txt
	TextBox.SelStart = 0
	TextBox.SelLength = TextBox.TextLength
	TextBox.Copy()
	If alt Then WScript.Echo "Copy Finished."
End Function

Function test_connect()
	Dim wsobj : Set wsobj = CreateObject("WScript.Shell")
	wsobj.run "cmd /c ping /n 2 www.midishow.com || (echo �޷����ӵ�www.midishow.com�� && echo ��������������ӡ� && echo �����Ǳ�ǽ�ˡ�ʹ��VPN�Խ��������⡣) | msg * /time:0",0,False
End Function