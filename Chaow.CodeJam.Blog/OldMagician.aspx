<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OldMagician.aspx.cs" Inherits="Chaow.CodeJam.Blog.OldMagician" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        สมมติมีลูกแก้วอยู่ในถุง<br />
        มีลูกแก้วสีขาวอยู่ W ลูก และสีดำ B ลูก<br />
        และเราสุ่มหยิบลูกแก้ว ถ้าได้สีเหมือนกัน เราจะใส่สีขาวเพิ่มลงไป<br />
        แต่ถ้าสีต่างกัน เราจะใส่สีดำเพิ่มเข้าไป<br />
        คำถามคือ ลูกแก้วลูกสุดท้ายในถุงจะเป็นสีอะไร<br />
        อ่านเพิ่ม <a href="https://code.google.com/codejam/contest/32004/dashboard">ที่นี่</a><br />
        <br />
        คำถามข้อนี้ง่ายมาก อยากให้คุณคิดให้ดีก่อนอ่านต่อไป<br />
        <br />
    <hr/>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        เมื่อเราหยิบลูกแก้ว จะมีผลลัพธ์อยู่&nbsp; 3 แบบ<br />
        1. ได้สีขาวและสีดำ แบบนี้เราจะได้สีดำคืนมา ดังนั้น เท่ากับหักสีขาวไป 1 ลูก<br />
        2. ได้สีขาว 2 ลูก แบบนี้เราจะได้สีขาวคืนมา 1 ลูก เท่ากับหักสีขาวไป 1 ลูก<br />
        3. ได้สีดำ 2 ลูก แบบนี้เราก็ได้สีขาวคืนมา 1 ลูก เท่ากับเพิ่มสีขาว 1 ลูก แต่หักสีดำไป 2 ลูก<br />
        <br />
        ดังนั้น หากเหลือสีดำลูกเดียว เราจะไม่มีวิธีกำจัดสีดำออกไปได้เลย<br />
        และในขณะเดียวกันถ้าสีดำเป็นเลขคู่ สุดท้ายสีดำจะถูกกำจัดออกไปเสมอ<br />
        ดังนั้น แค่เราดูจำนวนของสีดำ ก็ได้คำตอบแล้วครับ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;white&nbsp;black&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;(black&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;<span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#d69d85;">&quot;WHITE&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;<span style="color:#d69d85;">&quot;BLACK&quot;</span></pre>
        จบ</div>
    </form>
</body>
</html>
