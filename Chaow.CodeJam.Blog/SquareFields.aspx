<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SquareFields.aspx.cs" Inherits="Chaow.CodeJam.Blog.SquareFields" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        สมมติมีจุดหลายๆ จุดอยู่บนพื้นที่<br />
        เราต้องวางสี่เหลี่ยมจตุรัสจำนวน k อัน<br />
        เพื่อครอบคลุมจุดทั้งหมด โดยต้องวางขนานกับแกน x y<br />
        คำถามคือ ต้องใช้สี่เหลี่ยมขนาดเล็กที่สุดขนาดเท่าไหร่ถึงจะครอบคลุมจุดทั้งหมด<br />
        อ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32004/dashboard#s=p1">ที่นี่</a><br />
        <br />
        เนื่องจากโจทย์กำหนดว่า ขนาดของพื้นที่ที่ใหญ่ที่สุดคือ 64,000<br />
        ดังนั้น วิธีการแก้ปัญหาคือ Binary Search<br />
        เราแค่ต้องหาว่า สี่เหลี่ยมขนาด x จำนวน k อัน จะครอบคลุมจุดทั้งหมดได้หรือไม่<br />
        <br />
        เริ่มจาก ประกาศ function<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;sets&nbsp;sqrs&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        sets คือจุดต่างๆ<br />
        sqrs คือจำนวนสี่เหลี่ยมจตุรัส<br />
        <br />
        ถัดมาคือ function เพื่อหาว่าสี่เหลี่ยมจตุรัสจะสามารถครอบคลุมจุดทั้งหมดได้หรือไม่<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;matchSqr&nbsp;size&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;matchSqrX&nbsp;sets&nbsp;sqrs&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>count&nbsp;sets&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;sqrs&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>singleton&nbsp;size
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">elif</span>&nbsp;sqrs&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>empty
</pre>
        function ชื่อ matchSqr<br />
        size คือขนาดของสี่เหลี่ยมจตุรัส<br />
        <br />
        เราสร้างอีก function (matchSqrX) เพื่อทำ recursive<br />
        ถ้า จำนวนจุดที่เหลือ (sets) &lt;= จำนวนสี่เหลี่ยม (sqrs)<br />
        หมายความว่าเราสามารถใช้สี่เหลี่ยมหนึ่งอัน ต่อหนึ่งจุด และได้คำตอบทันที<br />
        แต่ถ้า จำนวนสี่เหลี่ยม (sqrs) เหลือ 0 แปลว่าไม่มีคำตอบ<br />
        <br />
        function ยังไม่จบ มีต่อ            <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;x,y&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>minElement&nbsp;sets
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;ys1&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;sets&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(x2,y2)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;x&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;x<span style="color:#b4b4b4;">+</span>size&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;y2&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;y<span style="color:#b4b4b4;">-</span>size&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;y2&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;y)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;snd
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>ofSeq
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;ys2&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;sets&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(x2,y2)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;x&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;x<span style="color:#b4b4b4;">+</span>size&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;y2&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;y&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;y2&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;y<span style="color:#b4b4b4;">+</span>size)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;snd
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;y2&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;y2&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;size)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>ofSeq
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;ys&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;ys1&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;ys2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>singleton&nbsp;y
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;y&nbsp;<span style="color:#569cd6;">in</span>&nbsp;ys&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;coveredSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;sets&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(x2,y2)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;x&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;x2&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;x<span style="color:#b4b4b4;">+</span>size&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;y2&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;y&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;y2&nbsp;<span style="color:#b4b4b4;">&lt;=</span>&nbsp;y<span style="color:#b4b4b4;">+</span>size)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>ofSeq
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;i&nbsp;<span style="color:#569cd6;">in</span>&nbsp;matchSqrX&nbsp;(sets<span style="color:#b4b4b4;">-</span>coveredSet)&nbsp;(sqrs<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;i
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}
&nbsp;&nbsp;&nbsp;&nbsp;matchSqrX&nbsp;sets&nbsp;sqrs</pre>
        ตอนแรก เราดีงเฉพาะจุดที่น้อยที่สุด (x,y) ออกมาจาก sets<br />
        เนื่องจาก x น้อยที่สุด เราแน่ใจได้เลยว่ามันจะเป็นจุดที่อยู่ซ้ายที่สุด<br />
        เราสามารถวางสี่เหลี่ยมชนจุดทางด้านซ้ายได้เลย<br />
        <br />
        ต่อมาเราก็เลื่อนสี่เหลี่ยมไปบนสุด คือด้านล่างของสี่เหลี่ยมชนจุด y<br />
        แล้วเราก็ list จุด y ต่างๆ ที่เจอออกมา (ys1)<br />
        เช่นเดียวกัน ทีนี้ลองเลื่อนสี่เหลี่ยมไปล่างสุด ด้านบนของสี่เหลี่ยมชนจุด y<br />
        แล้วเราก็ list จุด y ต่างๆ ออกมา (ys2)<br />
        <br />
        ys ก็คือจุด y ทั้งหมดที่สี่เหลี่ยมจะเลื่อนขึ้นและลงได้<br />
        ทีนี้ก็ loop เลยครับ ลองทุกวิธี<br />
        coveredSet คือ จุดที่โดนครอบโดยสี่เหลี่ยม<br />
        แล้วเราก็ recursive เพื่อลองต่อไป<br />
        <br />
        สุดท้าย ก็หาขนาดที่เล็กที่สุดด้วย binary search<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;binarySearch&nbsp;min&nbsp;max&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;min&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;max&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;max
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;mid&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(min&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;max)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;matchSqr&nbsp;mid
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>isEmpty&nbsp;result&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;binarySearch&nbsp;(mid<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1</span>)&nbsp;max
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;binarySearch&nbsp;min&nbsp;mid
binarySearch&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#b5cea8;">64000</span>&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;string</pre>
        จบ<br />
    
    </div>
    </form>
</body>
</html>
