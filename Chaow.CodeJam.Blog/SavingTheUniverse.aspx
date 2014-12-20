<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SavingTheUniverse.aspx.cs" Inherits="Chaow.CodeJam.Blog.SavingTheUniverse" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        เรื่องมีอยู่ว่า โลกของเรามี Search Engine อยู่หลายเจ้า<br />
        แต่รู้ไหมครับว่า เราไม่สามารถใส่ keyword ตรงกับ ชื่อของ Search Engine<br />
        เช่น ถ้าคุณ search &quot;Google&quot; บน Google จักรวาลจะระเบิดทันที !!!<br />
        <br />
        หน้าที่คุณคือปกป้องจักรวาลแห่งนี้<br />
        ระบบจะป้อนชื่อของ Search Engine ต่างๆ และรายการ keyword ต่างๆ<br />
        ระบบคุณจะต้องบอกได้ว่า ระบบคุณจะสลับ Search Engine อย่างน้อยกี่ครั้ง<br />
        อ่านต่อ <a href="https://code.google.com/codejam/contest/32013/dashboard">ที่นี่</a><br />
        <br />
        วิธีคิดก็ง่ายมาก แต่ต้องรู้จัก <a href="http://en.wikibooks.org/wiki/F_Sharp_Programming/Sets_and_Maps">Set</a> ใน F#<br />
        โครงสร้างของ Set จะเป็น binary tree ซึ่งสมาชิกจะไม่ซ้ำกัน<br />
        ทีนี้เราก็สร้าง set มา set นึง<br />
        แล้วป้อน keyword ไปเรื่อยๆ ซึ่ง Search Engine ที่จะมา search set นี้<br />
        คือ Search Engine สุดท้ายที่กำลังใส่ใน set นี้<br />
        แต่ก่อนใส่ เราก็สลับ set ใหม่เข้ามา ทีนี้เราก็ปกป้องจักรวาลได้แล้ว<br />
        <br />
        ใน F# เราสามารถสรุป logic ด้านบนใน function เดียว<br />
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;s&nbsp;list&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;run&nbsp;list&nbsp;set&nbsp;times&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;list&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;[]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;times
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;head<span style="color:#b4b4b4;">::</span>tail&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;Set<span style="color:#b4b4b4;">.</span>add&nbsp;head&nbsp;set
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;Set<span style="color:#b4b4b4;">.</span>count&nbsp;newSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;s
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;run&nbsp;tail&nbsp;(Set<span style="color:#b4b4b4;">.</span>singleton&nbsp;head)&nbsp;(times<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;run&nbsp;tail&nbsp;newSet&nbsp;times
 
&nbsp;&nbsp;&nbsp;&nbsp;run&nbsp;list&nbsp;Set<span style="color:#b4b4b4;">.</span>empty&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;string</pre>
        s คือ จำนวนของ Search Engine<br />
        list คือ รายการของ keyword<br />
        <br />
        function run เป็น recursive ที่จะ return ค่าว่าต้องสลับ set กี่ครั้ง<br />
        โดยที่ ถ้ารายการ keyword หมด ([]) เราก็ return จำนวนครั้ง<br />
        แต่ถ้ามี keyword เหลืออยู่ (head::tail) เราก็เอา head ใส่ set<br />
        หลังจากนั้นก็ count สมาชิกใน set ถ้าครบตามจำนวน Search Engine ก็เริ่ม set ใหม่ และเพิ่มจำนวนครั้งเข้าไป<br />
        <br />
        จบ<br />
    
    </div>
    </form>
</body>
</html>
