<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Numbers.aspx.cs" Inherits="Chaow.CodeJam.Blog.Numbers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อนี้ให้หา 3 หลักสุดท้ายก่อนจุดทศนิยมของ (3 + √5)<sup><b>n</b></sup>
        <br />
        เช่น (3 + √5)<sup><b>5</b></sup> = 3935.73982... ก็ให้ตอบ 935<br />
        <br />
        ข้อนี้ถ้าคูณธรรมดาผิดแน่นอนครับ ใน large set ยกกำลังถึง 2,000,000,000<br />
        precision ไม่พอแน่นอน<br />
        <br />
        ทีนี้ลองแทนค่า √5 ด้วย x และแทนตัวบวกตัวคูณเป็น a กับ b
        <br />
        ก็จะเป็น a + bx<br />
        <br />
        ทีนี้ function คูณก็จะง่ายแล้ว (a<sub>1</sub> + b<sub>1</sub>x) * (a<sub>2</sub> + b<sub>2</sub>x) เขียนเป็น function ได้ดังนี้<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;(<span style="color:#b4b4b4;">.*.</span>)&nbsp;(a1,&nbsp;b1)&nbsp;(a2,&nbsp;b2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;a1<span style="color:#b4b4b4;">*</span>a2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;b1<span style="color:#b4b4b4;">*</span>b2<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">5</span>,&nbsp;a1<span style="color:#b4b4b4;">*</span>b2&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;a2<span style="color:#b4b4b4;">*</span>b1</pre>
        เรารู้อยู่แล้วว่า x^2 จะได้ 5 จึงแทนค่าด้วย 5 ได้เลย<br />
        <br />
        อีก function นึงสำหรับ mod<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;(<span style="color:#b4b4b4;">.%.</span>)&nbsp;(a,&nbsp;b)&nbsp;m&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;a&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;m,&nbsp;b&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;m</pre>
        ไม่มีอะไร แค่ mod a และ b<br />
        <br />
        ถัดมาเป็น function สำหรับทำ <a href="http://en.wikipedia.org/wiki/Modular_exponentiation">modPow</a><pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;modPow&nbsp;num&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;num
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;exp&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;modPow&nbsp;(num&nbsp;<span style="color:#b4b4b4;">.*.</span>&nbsp;num&nbsp;<span style="color:#b4b4b4;">.%.</span>&nbsp;<span style="color:#b5cea8;">1000</span>)&nbsp;(exp&nbsp;<span style="color:#b4b4b4;">&gt;&gt;&gt;</span>&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;exp&nbsp;<span style="color:#b4b4b4;">&amp;&amp;&amp;</span>&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;num&nbsp;<span style="color:#b4b4b4;">.*.</span>&nbsp;result&nbsp;<span style="color:#b4b4b4;">.%.</span>&nbsp;<span style="color:#b5cea8;">1000</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;result</pre>
        อันนี้ค่อนข้างตรงสูตร ลองอ่านเพิ่มเติมใน wiki ดูนะครับ<br />
        <br />
        ถัดมา หลังจากได้คำตอบแล้วจะถอดออกมาอย่างไร เช่น<br />
        (3 + √5)<sup><b>2</b></sup> จะได้ 14 + 6x
        <br />
        ถึงตอนนี้ เราจะแทน x ด้วย √5 ตรงๆ ไม่ได้เพราะ 6 ถูก mod มาก่อนหน้าแล้ว<br />
        ซึ่งอาจจะมีค่าเป็น 1006 ก็ได้<br />
        <br />
        ทีนี้ลองพิจารณา <a href="http://en.wikipedia.org/wiki/Conjugate_(algebra)">conjugate</a> ของ 3 + √5 ซึ่งก็คือ 3 - √5<br />
        3 - √5 มีค่าเท่ากับ 0.76... ซึ่งเมื่อยกกำลังไปเรื่อยๆ ก็มีค่าไม่เกิน 0<br />
        ดังนั้นคำตอบเท่ากับ
        <br />
        <br />
        = (3 + √5)<sup><b>n</b></sup> + (3 - √5)<sup><b>n</b></sup> - (3 - √5)<sup><b>n</b></sup>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <br />
        = (a + bx) + (a - bx) - 1<br />
        = 2a - 1<br />
        <br />
        (3 - √5)<sup><b>n</b></sup> เราแปลงเป็น 1 ไปเลยเพราะเราไม่สนใจเศษทศนิยม<br />
        เอา 2a - 1 มาเป็น function คำตอบ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;exp&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;a,&nbsp;_&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;modPow&nbsp;(<span style="color:#b5cea8;">3</span>,<span style="color:#b5cea8;">1</span>)&nbsp;exp
&nbsp;&nbsp;&nbsp;&nbsp;(a<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">2</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">999</span>)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">1000</span>&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;sprintf&nbsp;<span style="color:#d69d85;">&quot;</span><span style="color:#4edcb0;">%03d</span><span style="color:#d69d85;">&quot;</span></pre>
        เราเปลี่ยน -1 เป็น 999 เพราะมี mod มาเกี่ยวข้อง
        <br />
        ดังนั้นเมื่อ a เป็น 0 จะได้ 999 ไม่ใช่ -1<br />
        <br />
        จบ
        <br />
        </div>
    </form>
</body>
</html>
