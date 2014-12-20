<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Milkshakes.aspx.cs" Inherits="Chaow.CodeJam.Blog.Milkshakes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        คราวนี้สมมติว่าเราเป็นผู้จัดการร้านนมปั่น<br />
        ซึ่งร้านเราจะขายหลายรสชาติ และแต่ละรสก็แบ่งเป็น malt กับ unmalt<br />
        และเราก็มีลูกค้าหลายคน แต่ละคนก็ชอบไม่เหมือนกัน<br />
        บางทีก็ชอบหลายรส แต่ลูกค้าจะชอบแบบ malt แค่รสเดียวเท่านั้น<br />
        <br />
        โจทย์สั่งให้เราจัดเตรียมวัตถุดิบ โดยที่ให้มี malt น้อยที่สุด<br />
        <br />
        โจทย์ประเภท <a href="http://en.wikipedia.org/wiki/Constraint_satisfaction_problem">constraint satisfaction problem</a> เนี่ย ไม่มีอะไรเหมาะเท่า F# อีกแล้วครับ<br />
        เวลาคิดก็เหมือนเล่น Sudoku เลือกตัวเลือกที่มีตัวเลือกน้อยที่สุดก่อน<br />
        แล้วเมื่อเลือกแล้ว ก็ตัด choice ออกไปเรื่อยๆ<br />
        <br />
        ก่อนเริ่มเรามาสร้าง module กันเล่นๆ ก่อน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">module</span>&nbsp;<span style="color:#4ec9b0;">Map</span>&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;count&nbsp;(map<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">&lt;</span>_,_<span style="color:#b4b4b4;">&gt;</span>)&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;map<span style="color:#b4b4b4;">.</span>Count</pre>
        เดิมที f# มี module ชื่อ <a href="http://msdn.microsoft.com/en-us/library/ee353880.aspx">Map</a> อยู่แล้ว<br />
        ใน f# เราสามารถ เพิ่ม function เข้าไปใน module ที่มีอยู่แล้วได้<br />
        ในที่นี้ คือการเพิ่ม function count<br />
        <br />
        เริ่มเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;n&nbsp;custs&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        n คือ จำนวนรสชาติ<br />
        cust เป็น รายการ (seq) ของ map ที่บอกว่าลูกค้าแต่ละคนชอบรสอะไรบ้าง และมีค่าเป็น malt หรือ unmalt<br />
        <br />
        ถัดมาคือ function หลัก<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;logic&nbsp;map&nbsp;custs&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;custs&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;custs&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sortBy&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>count
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>toList
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;custs&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;[]&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>singleton&nbsp;map
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;head<span style="color:#b4b4b4;">::</span>tail&nbsp;<span style="color:#569cd6;">-&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;prefs&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;head&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>toSeq
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sortBy&nbsp;snd
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;a,&nbsp;b&nbsp;<span style="color:#569cd6;">in</span>&nbsp;prefs&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newMap&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>add&nbsp;a&nbsp;b&nbsp;map
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;notMatch&nbsp;choices&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;item&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>tryFind&nbsp;a&nbsp;choices
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;item<span style="color:#b4b4b4;">.</span>IsNone&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;item<span style="color:#b4b4b4;">.</span>Value&nbsp;<span style="color:#b4b4b4;">&lt;&gt;</span>&nbsp;b
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newCusts&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;tail&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>where&nbsp;notMatch
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>remove&nbsp;a)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield!</span>&nbsp;logic&nbsp;newMap&nbsp;newCusts
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}</pre>
        map คือ map ของรสชาติต่างๆ ที่เราจะขาย และมีค่าเป็น malt หรือ unmalt<br />
        <br />
        ตอนแรกเราก็เรียง custs ก่อน ใครมี choice น้อยสุดก็เลือกก่อน<br />
        ถ้า custs หมดแล้ว ([]) ก็คือจบ เราได้คำตอบแล้ว<br />
        <br />
        แต่ถ้า custs ยังไม่หมด (head::tail)<br />
        prefs คือ ตัวเลือกของลูกค้า โดยที่เราจะเรียงเอาแบบ unmalt ก่อน<br />
        แล้วทีนี้ก็ลองตัวเลือกของลูกค้าทีละอัน<br />
        newMap คือ รสชาติที่เราจะขาย โดยเพิ่มตัวเลือกของลูกค้าเข้าไป<br />
        newCusts คือ ลูกค้าที่ยังไป satisfy และเราก็ตัดตัวเลือกรสเดียวกันออกไป (เช่น ลูกค้าชอบ unmalt แต่เราจะขาย malt)<br />
        แล้วก็วนไปเรื่อยๆ<br />
        <br />
        เสร็จแล้วก็คืนค่า<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;custs&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;logic&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>empty
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>truncate&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>toList
<span style="color:#569cd6;">match</span>&nbsp;result&nbsp;<span style="color:#569cd6;">with</span>
|&nbsp;[]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;IMPOSSIBLE&quot;</span>
|&nbsp;head<span style="color:#b4b4b4;">::</span>_&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;createFn&nbsp;i&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>tryFind&nbsp;(i<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1</span>)&nbsp;head&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;None&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;0&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Some(j)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;string&nbsp;(j&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;strs&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>init&nbsp;n&nbsp;createFn
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">String</span><span style="color:#b4b4b4;">.</span>Join(<span style="color:#d69d85;">&quot;&nbsp;&quot;</span>,&nbsp;strs)</pre>
        โดย result เราจะเอาแค่คำตอบแรกเท่านั้น<br />
        <br />
        จบ</div>
    </form>
</body>
</html>
