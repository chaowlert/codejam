<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EggDrop.aspx.cs" Inherits="Chaow.CodeJam.Blog.EggDrop" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อถัดมา <a href="https://code.google.com/codejam/contest/32003/dashboard#s=p2">Egg Drop</a><br />
        โจทย์เกี่ยวกับการทดลองโยนไข่จากตึก เพื่อหาว่าไข่จะแตกจากชั้นที่เท่าไหร่<br />
        โดย input จะมี<br />
        จำนวนชั้นของตึก (F)<br />
        จำนวนไข่ (D)<br />
        จำนวนไข่ที่แตกได้ (B)<br />
        <br />
        ข้อนี้ข้อเดียวให้หาถึง 3 คำตอบ<br />
        จำนวนชั้นของตึกที่มากที่สุด (FMax)<br />
        จำนวนไข่ที่น้อยที่สุด (DMin)<br />
        จำนวนไข่ที่แตกได้น้อยที่สุด (BMin)<br />
        ลองไปอ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32003/dashboard#s=p2">ที่นี่</a><br />
        <br />
        เริ่มจาก FMax<br />
        ข้อนี้สามารถ Solve ได้โดยง่ายด้วย <a href="http://en.wikipedia.org/wiki/Dynamic_programming">Dynamic Programming</a><br />
        คือ แทนที่จะคิดว่าจะหาสูตรอะไรเพื่อคำนวนได้ FMax<br />
        เราก็แตก FMax เป็น subproblem แทน ได้มาเป็นสูตรนี้<br />
        <br />
        FMax(d, b) = 1 + FMax(d-1,b) + FMax(d-1,b-1)<br />
        <br />
        1 ตัวแรกคือ เมื่อโยนไข่ 1 ที เราก็รู้ว่าชั้นที่โยนแตกหรือไม่แตก<br />
        FMax(d-1,b) คือ ถ้าโยนแล้วไม่แตก เราก็ขึ้นไปชั้นบนเพื่อโยนต่อไป<br />
        d-1 คือ จำนวนไข่จะลดลง 1 และ b คือ จำนวนไข่ที่แตกยังเท่าเดิม เพราะโยนแล้วไม่แตก<br />
        FMax(d-1,b-1) คือ ถ้าโยนแล้วแตก เราจะลงชั้นล่าง เพื่อโยนต่อไป<br />
        คราวนี้จะเห็นว่าเป็น b-1 คือ จำนวนไข่ที่แตกลดลงไป 1<br />
        <br />
        โดยมาก Dynamic Programming จะมาคู่กับ <a href="http://en.wikipedia.org/wiki/Memoization">Memoization</a><br />
        เพราะเราอาจจะเรียก input แบบเดิมซ้ำแล้วซ้ำอีก<br />
        เราควรจะบันทึกคำตอบ ดีกว่าจะคำนวนใหม่อีกครั้ง<br />
        <br />
        นี้เป็นคำสั่ง Memoize<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;memoize&nbsp;f&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;dict&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Dictionary</span><span style="color:#b4b4b4;">&lt;</span>_,_<span style="color:#b4b4b4;">&gt;</span>()
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">fun</span>&nbsp;n&nbsp;<span style="color:#569cd6;">-&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;dict<span style="color:#b4b4b4;">.</span>TryGetValue(n)&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#569cd6;">true</span>,&nbsp;v&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;v
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;_&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;v&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;f(n)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dict<span style="color:#b4b4b4;">.</span>Add(n,&nbsp;v)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;v</pre>
        หลักๆ คือใช้ dict ถ้าเคยเห็น input (n) แบบนี้แล้ว ก็ return value (v) ทันที<br />
        แต่ถ้าไม่เคย ก็คำนวน (f) แล้วเอาค่ามาเก็บใน dict<br />
        <br />
        คราวนี้มาต่อกับ FMax<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;maxFx&nbsp;(d,&nbsp;b)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">1L</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;maxF&nbsp;(d&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>,&nbsp;b)&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;maxF&nbsp;(d&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>,&nbsp;b&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;<span style="color:#b5cea8;">4294967296L</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1L</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;result
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;cache&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;memoize&nbsp;maxFx
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;int64&nbsp;d
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;b&nbsp;<span style="color:#569cd6;">when</span>&nbsp;d&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;b&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;(<span style="color:#b5cea8;">1L</span>&nbsp;<span style="color:#b4b4b4;">&lt;&lt;&lt;</span>&nbsp;b)&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1L</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;b&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;cache&nbsp;(d,&nbsp;b)</pre>
        วิธีการหา result อธิบายไปแล้วด้านบน<br />
        มีเพิ่มจากที่อธิบายไปก่อนหน้านิดนึง<br />
        โจทย์สั่งว่าถ้า result มีค่ามากกว่าเท่ากับ 2<sup>32</sup><br />
        ให้ return -1<br />
        <br />
        และถัดมา cache คือ การสั่ง memoize เพื่อจำคำตอบ<br />
        อะไรที่เรียกจาก cache จะมีการคำนวนเพียงครั้งเดียวเท่านั้น<br />
        <br />
        ถัดมา คือการคืนค่าโดยไม่ต้องผ่าน cache<br />
        ซึ่งค่าบางอย่าง เราสามารถคำนวนสดได้เลย ไม่ต้องผ่าน dynamic programming<br />
        <br />
        เริ่มจาก
        ถ้า b = 1 คือ ไข่แตกได้แค่ฟองเดียว<br />
        ถ้ามีไข่อยู่ 10 ฟอง แต่แตกได้แค่ฟองเดียว<br />
        เราก็โยนจากชั้นล่างขึ้นไปเรื่อยๆ จำนวนชั้นที่มากที่สุดคือ 10 ชั้น<br />
        ดังนั้น ถ้า b = 1 และ d = 10 คือตอบคือ 10<br />
        <br />
        และถ้า d = b<br />
        มันจะกลายเป็น <a href="http://en.wikipedia.org/wiki/Binary_search">binary search</a> ทันที<br />
        จำนวน search space มากที่สุด สำหรับการค้นหา b ครั้งคือ 2<sup>b</sup> - 1<br />
        ซึ่งสามารถแปลงเป็น (1L &lt;&lt;&lt; b) - 1L<br />
        <br />
        แต่ function maxF ยังมีจุดอ่อนคือ<br />
        ถ้าจำนวนไข่ (d) มากกว่าจำนวนไข่ที่แตกได้ (b) มากๆ
        <br />
        เช่น จำนวนไข่มี 2 พันล้าน แต่ไข่ที่แตกได้มีแค่ 2<br />
        ทำให้เกิดการ recursion เกือบ 2 พันล้านครั้ง แน่นอนว่าจะเกิด stack overflow<br />
        และต่อให้ไม่เกิด stack overflow ก็ใช้เวลา search นานอยู่ดี<br />
        แต่เนื่องจากโจทย์บอกว่า ถ้า result เกิน 2<sup>32</sup> ให้ return -1 เสมอ<br />
        <br />
        อีกสูตรที่เราควรหาคือ หาว่า input ของ function maxF จะเป็น overflow หรือไม่<br />
        วิธีหาก็ <a href="http://en.wikipedia.org/wiki/Brute-force_search">brute force</a> เลยครับ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;isOverflow&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;maxD&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;brute&nbsp;d&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;maxF&nbsp;(d,&nbsp;b)&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1L</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;d&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;_&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;brute&nbsp;(d&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;brute&nbsp;(b&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;cache&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;memoize&nbsp;maxD
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">false</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;b&nbsp;<span style="color:#569cd6;">when</span>&nbsp;b&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;<span style="color:#b5cea8;">32</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">true</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;d,&nbsp;b&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;d&nbsp;<span style="color:#b4b4b4;">&gt;</span>&nbsp;cache&nbsp;b</pre>
        จากด้านบน คำสั่ง maxD เราก็แค่เพิ่ม d ไปเรื่อยๆ จนเจอ -1 เราก็หยุด<br />
        และก็มี function จัดการนิดหน่อยเพื่อไม่ต้องเรียกจาก cache<br />
        เช่น ถ้า b = 1 แล้ว d จะมีค่าเท่ากับ f เสมอ ตามที่อธิบายด้านบน ดังนั้นจึงไม่มีทาง overflow<br />
        และถ้า b &gt; 32 และ d จะมีค่าน้อยที่สุดคือ เท่ากับ b
        <br />
        และเมื่อเข้าสูตร binary search แล้ว f จะมีค่ามากกว่า 2<sup>32</sup> เสมอ<br />
        <br />
        คราวนี้เราเริ่มหาค่า FMax ได้ด้วย function นี้ครับ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;solveF&nbsp;d&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;d&nbsp;<span style="color:#b4b4b4;">&lt;</span>&nbsp;b&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;solveF&nbsp;d&nbsp;d
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">elif</span>&nbsp;isOverflow&nbsp;(d,&nbsp;b)&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1L</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;maxF&nbsp;(d,&nbsp;b)</pre>
        ถ้าจำนวนไข่ (d) น้อยกว่าจำนวนไข่ที่แตกได้ (b)<br />
        เช่น มีไข่อยู่ 8 ใบ แต่สามารถแตกได้ 10 ใบ
        <br />
        เมื่อไข่แตกไปแล้ว 8 ใบ จำนวนไข่ก็หมดไม่สามารถแตกได้อีกต่อไป<br />
        ดังนั้น กรณีนี้ จำนวนไข่ที่แตกได้ จะไม่มีวันมากกว่าจำนวนไข่เสมอ<br />
        <br />
        ถัดมา หาค่า DMin
        <br />
        ถ้าจำนวนชั้น (f) มีค่า 2 พันล้านชั้น<br />
        และไข่ที่แตกได้ (b) มีแค่ใบเดียว<br />
        จำนวนไข่ทั้งหมดที่ต้องมีคือ 2 พันล้านใบ<br />
        search space ขนาดนี้ binary search สามารถเอาอยู่<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solveD&nbsp;f&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;binarySearch&nbsp;low&nbsp;hi&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;low&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;hi&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;low
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;mid&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(low&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;hi)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">2</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;solveF&nbsp;mid&nbsp;b
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1L</span>&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;int64&nbsp;f
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;binarySearch&nbsp;low&nbsp;mid
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;binarySearch&nbsp;(mid&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>)&nbsp;hi
&nbsp;&nbsp;&nbsp;&nbsp;binarySearch&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;f</pre>
        ถัดมา หาค่า BMin<br />
        อันนี้เรารู้จากด้านบนแล้วว่า ถ้า b มีค่าเกิน 32 จะ overflow<br />
        ดังนั้นค่า b จะมีค่าแค่ 1-32 เท่านั้น ใช้ brute force ไปเลยสะดวกที่สุด<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solveB&nbsp;f&nbsp;d&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;brute&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;solveF&nbsp;d&nbsp;b
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1L</span>&nbsp;<span style="color:#b4b4b4;">||</span>&nbsp;maxF&nbsp;<span style="color:#b4b4b4;">&gt;=</span>&nbsp;int64&nbsp;f&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;b
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;brute&nbsp;(b&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;brute&nbsp;<span style="color:#b5cea8;">1</span></pre>
        สุดท้าย พิมพ์คำตอบ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;f&nbsp;d&nbsp;b&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;sprintf&nbsp;<span style="color:#d69d85;">&quot;%i&nbsp;%i&nbsp;%i&quot;</span>&nbsp;(solveF&nbsp;d&nbsp;b)&nbsp;(solveD&nbsp;f&nbsp;b)&nbsp;(solveB&nbsp;f&nbsp;d)</pre>
        จบ<br />
    
    </div>
    </form>
</body>
</html>
