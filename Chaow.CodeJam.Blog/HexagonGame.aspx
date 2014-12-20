<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HexagonGame.aspx.cs" Inherits="Chaow.CodeJam.Blog.HexagonGame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <style type="text/css" scoped>.auto-style1 {color: #333333;background-color: #CCCCCC;}</style>
    <div>
    
        สมมติว่าคุณกำลังเล่นหมากกระดานอยู่<br />
        หมากกระดานนี้ไม่ใช่ตาราง 4 เหลี่ยม แต่เป็น 6 เหลี่ยม<br />
        คุณมีเบี้ยอยู่จำนวนเท่าขนาดของตาราง เบี้ยแต่ละตัววางมั่วๆ บนกระดาน
        <br />
        เบี้ยสามารถเดินได้เฉพาะช่องที่ติดกัน<br />
        และเมื่อไหร่ที่เบี้ยเรียงกันทุกตัวคุณชนะ<br />
        ยังไม่จบ เบี้ยแต่ละตัวมีแต้มไม่เท่ากัน
        <br />
        หากเดินเบี้ย 1 ครั้ง คุณจะต้องเสียแต้มตามที่กำหนดบนเบี้ย<br />
        คำถามคือ คุณจะสามารถชนะได้โดยเสียแต้มน้อยที่สุดกี่คะแนน<br />
        อ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32014/dashboard#s=p3">ที่นี่</a><br />
        <br />
        <img alt="" src="https://code.google.com/codejam/contest/static/hexagon.png" /><br />
        <br />
        ข้อนี้เป็นโจทย์ประเภทกำหนดงาน<br />
        คือ ต้องหาว่าเบี้ยตัวไหนจะเดินไปที่ตำแหน่งไหน<br />
        หากไม่รู้จัก algorithm เราคงใช้วิธีการ brute force O(n!)<br />
        ทีนี้ มันมี algorithm ตัวนึง ที่เพิ่มประสิทธิภาพในการจัดสรรงาน เป็น O(n<sup>3</sup>)<br />
        algorithm ตัวนี้คือ <a href="http://en.wikipedia.org/wiki/Hungarian_algorithm">Hungarian Algorithm</a><br />
        <br />
        เรียนรู้จัก algorithm ตัวนี้ไว้ก็ไม่เสียหาย<br />
        เราสามารถเอา algorithm นี้ ไปแก้ปัญหาการจัดสรรทรัพยากรในธุรกิจได้<br />
        ทีนี้ตัว code ก็ไม่ต้องเขียนเอง ไป download <a href="http://blog.noldorin.com/2009/09/hungarian-algorithm-in-csharp/">ที่นี่</a><br />
        <br />
        มาเริ่มกันเลย เรามาสร้างตารางกันก่อน<br />
        วิธีคิดตารางก็ต้องใช้จินตนาการนิดนึง เพราะตารางไม่ใช่สี่เหลี่ยม<br />
        สำหรับผม ผมให้ตารางมันเว้นช่องว่าง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#b4b4b4;">|..|..|</span><span style="color:#b5cea8;">01</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">02</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">03</span><span style="color:#b4b4b4;">|..|..|</span>
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">04</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">05</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">06</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">07</span><span style="color:#b4b4b4;">|..|</span>
|<span style="color:#b5cea8;">08</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">09</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">10</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">11</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">12</span>|
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">13</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">14</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">15</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">16</span><span style="color:#b4b4b4;">|..|</span>
<span style="color:#b4b4b4;">|..|..|</span><span style="color:#b5cea8;">17</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">18</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">19</span><span style="color:#b4b4b4;">|..|..|</span></pre>
        เราไม่ต้องสร้างตารางจริงๆ<br />
        เราแค่รู้ว่าเลขต่างๆ อยู่ตำแหน่งไหนก็พอ<br />
        เช่น เลข 1 อยู่ตำแหน่งที่ (0,2)<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;getBoard&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;getBoardX&nbsp;size&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;mid&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(size&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;width&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(size&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;<span style="color:#b5cea8;">2</span>)&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;row&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">to</span>&nbsp;size&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;rowPadding&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;abs&nbsp;(mid&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;row)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;col&nbsp;<span style="color:#569cd6;">in</span>&nbsp;{&nbsp;<span style="color:#b5cea8;">1</span><span style="color:#b4b4b4;">+</span>rowPadding&nbsp;<span style="color:#b4b4b4;">..</span>&nbsp;<span style="color:#b5cea8;">2</span>&nbsp;<span style="color:#b4b4b4;">..</span>&nbsp;width<span style="color:#b4b4b4;">-</span>rowPadding&nbsp;}&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;col,row
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>append&nbsp;[<span style="color:#b5cea8;">0</span>,<span style="color:#b5cea8;">0</span>]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>toArray
 
&nbsp;&nbsp;&nbsp;&nbsp;memoize&nbsp;getBoardX</pre>
        คำสั่ง getBoard มีไว้หาตำแหน่งของเลขต่างๆ<br />
        <br />
        ทีนี้ การวัดระยะห่างของช่องก็คำนวนง่ายนิดเดียว<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;(<span style="color:#b4b4b4;">&lt;-&gt;</span>)&nbsp;(x1,y1)&nbsp;(x2,y2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;deltaY&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;abs&nbsp;(y1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;y2)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;deltaX&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;abs&nbsp;(x1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;x2)&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;deltaY&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;max&nbsp;<span style="color:#b5cea8;">0</span>
&nbsp;&nbsp;&nbsp;&nbsp;deltaY&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;(deltaX&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2</span>)</pre>
        ถ้ามีการเลื่อนในแนวตั้ง เราสามารถเอามาลบแนวนอนได้ เพราะเวลาเลื่อนในแนวตั้ง เราเลื่อนแนวทแยง<br />
        และเวลาเลื่อนแนวนอน เวลาหาระยะห่างเราเอามาหาร 2 เพราะตารางมีการเว้นช่องว่างระหว่างเลข<br />
        <br />
        ถัดมาคือหาตำแหน่งจบ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;finishPos&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;finishPosX&nbsp;size&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;board&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;getBoard&nbsp;size
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;mid&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(size&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;finish1&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;col,row&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;board<span style="color:#4ec9b0;">.</span>[<span style="color:#b5cea8;">1</span>]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[|&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">to</span>&nbsp;size<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;col<span style="color:#b4b4b4;">+</span>i,row<span style="color:#b4b4b4;">+</span>i&nbsp;|]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;finish2&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;col,row&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;board<span style="color:#4ec9b0;">.</span>[mid]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[|&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">to</span>&nbsp;size<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;col<span style="color:#b4b4b4;">-</span>i,row<span style="color:#b4b4b4;">+</span>i&nbsp;|]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;finish3&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[|&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">to</span>&nbsp;size<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;(i<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">2</span>),mid&nbsp;|]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[|&nbsp;finish1;&nbsp;finish2;&nbsp;finish3&nbsp;|]
&nbsp;&nbsp;&nbsp;&nbsp;memoize&nbsp;finishPosX</pre>
        ตำแหน่งจบมี 3 แบบเสมอ คือ<br />
        จบแบบแนวนอน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#b4b4b4;">|..|..|</span><span style="color:#b5cea8;">01</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">02</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">03</span><span style="color:#b4b4b4;">|..|..|</span>
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">04</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">05</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">06</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">07</span><span style="color:#b4b4b4;">|..|</span>
|<span class="auto-style1">08</span><span style="color:#b4b4b4;">|..|<span class="auto-style1">09</span>|..|<span class="auto-style1">10</span>|..|<span class="auto-style1">11</span>|..|</span><span class="auto-style1">12</span>|
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">13</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">14</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">15</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">16</span><span style="color:#b4b4b4;">|..|</span>
<span style="color:#b4b4b4;">|..|..|</span><span style="color:#b5cea8;">17</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">18</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">19</span><span style="color:#b4b4b4;">|..|..|</span></pre>
        และแนวทแยง ซ้ายขวา<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#b4b4b4;">|..|..|<span style="color: #b4b4b4;"><span class="auto-style1">01</span></span>|..|</span><span style="color:#b5cea8;">02</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">03</span><span style="color:#b4b4b4;">|..|..|</span>
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">04</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">05</span></span>|..|</span><span style="color:#b5cea8;">06</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">07</span><span style="color:#b4b4b4;">|..|</span>
|<span style="color:#b5cea8;">08</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">09</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">10</span></span>|..|</span><span style="color:#b5cea8;">11</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">12</span>|
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">13</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">14</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">15</span></span>|..|</span><span style="color:#b5cea8;">16</span><span style="color:#b4b4b4;">|..|</span>
<span style="color:#b4b4b4;">|..|..|</span><span style="color:#b5cea8;">17</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">18</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">19</span></span>|..|..|</span></pre>
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#b4b4b4;">|..|..|</span><span style="color:#b5cea8;">01</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">02</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">03</span></span>|..|..|</span>
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">04</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">05</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">06</span></span>|..|</span><span style="color:#b5cea8;">07</span><span style="color:#b4b4b4;">|..|</span>
|<span style="color:#b5cea8;">08</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">09</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">10</span></span>|..|</span><span style="color:#b5cea8;">11</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">12</span>|
<span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">13</span><span style="color:#b4b4b4;">|..|<span style="color: #b4b4b4;"><span class="auto-style1">14</span></span>|..|</span><span style="color:#b5cea8;">15</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">16</span><span style="color:#b4b4b4;">|..|</span>
<span style="color:#b4b4b4;">|..|..|<span style="color: #b4b4b4;"><span class="auto-style1">17</span></span>|..|</span><span style="color:#b5cea8;">18</span><span style="color:#b4b4b4;">|..|</span><span style="color:#b5cea8;">19</span><span style="color:#b4b4b4;">|..|..|</span></pre>
        เริ่มเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;nums&nbsp;costs&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        nums คือ ตำแหน่งเริ่มต้นของเบี้ยแต่ละตัว<br />
        costs คือ คะแนนของเบี้ยแต่ละตัว<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;size&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>length&nbsp;nums
<span style="color:#569cd6;">let</span>&nbsp;board&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;getBoard&nbsp;size
<span style="color:#569cd6;">let</span>&nbsp;start&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;nums&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>get&nbsp;board)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>zip&nbsp;costs
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache
<span style="color:#569cd6;">let</span>&nbsp;finish&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;finishPos&nbsp;size</pre>
        size คือขนาดของ board<br />
        start คือ คะแนน และ ตำแหน่งเริ่มต้นของเบี้ยแต่ละตัว ซึ่งตำแหน่งเปลี่ยนเป็น (x, y) แทนตัวเลข<br />
        finish คือ ตำแหน่งสิ้นสุดของเบี้ย ซึ่งมี 3 แบบ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;minCost&nbsp;finPos&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;matrix&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;array2D&nbsp;[|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;cost,&nbsp;pos&nbsp;<span style="color:#569cd6;">in</span>&nbsp;start&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;pos2&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;(pos&nbsp;<span style="color:#b4b4b4;">&lt;-&gt;</span>&nbsp;pos2)&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;cost)&nbsp;finPos
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|]
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;sol&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">HungarianAlgorithm</span><span style="color:#b4b4b4;">.</span>FindAssignments&nbsp;(<span style="color:#4ec9b0;">Array2D</span><span style="color:#b4b4b4;">.</span>copy&nbsp;matrix)
&nbsp;&nbsp;&nbsp;&nbsp;sol&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>mapi&nbsp;(<span style="color:#4ec9b0;">Array2D</span><span style="color:#b4b4b4;">.</span>get&nbsp;matrix)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sum
 
finish&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;minCost
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>min
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;string</pre>
        ทีนี้เวลาหาผลลัพธ์ ก็เอา finish แต่ละแบบมาดูว่าแบบไหนใช้คะแนนน้อยที่สุด<br />
        ใน minCost เรามีการสร้าง matrix โดยการใช้ความสามารถของ f# ที่เรียกว่า <a href="http://en.wikibooks.org/wiki/F_Sharp_Programming/Arrays">array comprehension</a><br />
        โดย matrix จะเก็บคะแนนที่ใช้ของเบี้ยแต่ละตัว และตำแหน่งสิ้นสุดแต่ละตำแหน่ง<br />
        หลังจากนั้นก็โยนใส่ hangarian algorithm ให้มันหาคะแนนที่น้อยที่สุดออกมา<br />
        <br />
        จบ<br />
        </div>
    </form>
</body>
</html>
