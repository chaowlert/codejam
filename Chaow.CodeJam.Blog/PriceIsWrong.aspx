<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PriceIsWrong.aspx.cs" Inherits="Chaow.CodeJam.Blog.PriceIsWrong" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อถัดมา <a href="https://code.google.com/codejam/contest/32014/dashboard#s=p1">Price is wrong</a><br />
        จริงๆ ข้อนี้ไม่เกี่ยวอะไรกับราคา<br />
        เค้าจะให้ตัวเลขเรามาชุดนึง ซึ่งเป็นราคาสินค้า<br />
        แล้วให้ตอบว่าต้องแก้ตัวเลขอย่างน้อยกี่ตัวจึงทำให้ตัวเลขเรียงกัน<br />
        แต่แทนที่จะตอบตัวเลข เราต้องตอบชื่อสินค้าที่ราคาผิด<br />
        อ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32014/dashboard#s=p1">ที่นี่</a><br />
        <br />
        ข้อนี้ก็ยังเป็น Dynamic Programming<br />
        จุดสนุกของ Dynamic Programming คือ การวิเคราะห์หา subproblem<br />
        ซึ่งบางครั้ง ต้องอาศัยการคิดนอกกรอบแบบสุดๆ<br />
        <br />
        วิธีคิดของข้อนี้คือ<br />
        ให้สมมติว่ามี ตัวเลขพิเศษมาประกบหัวท้าย เช่น<br />
        20 15 40 30 60<br />
        ให้เพิ่มตัวเลขน้อยสุด กับมากสุดเข้าไป เช่น เลข 0 และ 101 เป็น<br />
        0 20 15 40 30 60 101<br />
        แล้วลองหยิบตัวเลขมาตัวนึง เช่น 40<br />
        ทีนี้เราก็ได้ subproblem คือ เรียง 0 20 15 40 กับเรียง 40 30 60 100<br />
        <br />
        ดังนั้น เราจะได้สูตรว่า<br />
        <br />
        minGuess (min, max) = min { minGuess(min, i) + minGuess(i, max) }<br />
        <br />
        แค่นี้เองครับ ง่ายบ่<br />
        <br />
        ทีนี้ ตัวเลขที่เราจะเอามาเป็น node สำหรับแยก subproblem ต้องมีค่าระหว่าง min กับ max<br />
        เรามาสร้าง operator สำหรับทำ between กัน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">inline</span>&nbsp;(<span style="color:#b4b4b4;">&lt;.</span>)&nbsp;a&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;a,&nbsp;b
<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">inline</span>&nbsp;(<span style="color:#b4b4b4;">.&lt;</span>)&nbsp;(a,&nbsp;b)&nbsp;c&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;a&nbsp;<span style="color:#b4b4b4;">&lt;</span>&nbsp;b&nbsp;<span style="color:#b4b4b4;">&amp;&amp;</span>&nbsp;b&nbsp;<span style="color:#b4b4b4;">&lt;</span>&nbsp;c</pre>
        มี 2 operators เหตุเพราะว่า f# ไม่รองรับการทำ ternary operator<br />
        ทีนี้วิธีใช้ operator นี้คือ a &lt;. b .&lt; c<br />
        ดูแล้วเข้าใจง่ายฝุดๆ<br />
        <br />
        มาเริ่มกันเลยครับ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;names&nbsp;prices&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;prices&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>concat&nbsp;[[|<span style="color:#b5cea8;">0</span>|];&nbsp;prices;&nbsp;[|<span style="color:#b5cea8;">101</span>|]]
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;priceOf&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>get&nbsp;prices
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;nameOf&nbsp;n&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>get&nbsp;names&nbsp;(n<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>)</pre>
        names คือ array ของชื่อสินค้า<br />
        prices คือ ราคาของสินค้า และทีนี้เรามีการประกบ 0 กับ 101 เข้าไปหัวท้าย<br />
        priceOf กับ nameOf คือการดึงราคาและชื่อ โดยใส่ index เข้าไป<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;minGuess&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;minGuessX&nbsp;(min,&nbsp;max)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;inside&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;{&nbsp;min<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1..</span>max<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;i&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;priceOf&nbsp;min&nbsp;<span style="color:#b4b4b4;">&lt;.</span>&nbsp;priceOf&nbsp;i&nbsp;<span style="color:#b4b4b4;">.&lt;</span>&nbsp;priceOf&nbsp;max)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>isEmpty&nbsp;inside&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;{&nbsp;min<span style="color:#b4b4b4;">+</span><span style="color:#b5cea8;">1..</span>max<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;nameOf
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Set</span><span style="color:#b4b4b4;">.</span>ofSeq
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;newSet<span style="color:#b4b4b4;">.</span>Count,&nbsp;newSet
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;i&nbsp;<span style="color:#569cd6;">in</span>&nbsp;inside&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;leftCount,leftSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;minGuess&nbsp;(min,&nbsp;i)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;rightCount,rightSet&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;minGuess&nbsp;(i,&nbsp;max)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;leftCount<span style="color:#b4b4b4;">+</span>rightCount,&nbsp;leftSet<span style="color:#b4b4b4;">+</span>rightSet
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>min
&nbsp;&nbsp;&nbsp;&nbsp;memoize&nbsp;minGuessX</pre>
        บรรทัด let inside คือ ดึงเฉพาะตัวเลขที่ราคาอยู่ระหว่าง min กับ max<br />
        ถ้าไม่เจอ inside หมายความว่าต้องปรับราคาทุกตัว<br />
        แต่ถ้าเจอ ก็ใช้ inside เป็น node แล้วหา minGuess ทั้งด้านซ้ายและด้านขวา<br />
        แล้ว return ผลเฉพาะค่า minimum<br />
        <br />
        สุดท้ายก็ return ผล<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;_,set&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;minGuess&nbsp;(<span style="color:#b5cea8;">0</span>,&nbsp;prices<span style="color:#b4b4b4;">.</span>Length&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>)
<span style="color:#4ec9b0;">String</span><span style="color:#b4b4b4;">.</span>Join(<span style="color:#d69d85;">&quot;&nbsp;&quot;</span>,&nbsp;set)</pre>
        จบ</div>
    </form>
</body>
</html>
