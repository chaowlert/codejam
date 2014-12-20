<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AlwaysTurnLeft.aspx.cs" Inherits="Chaow.CodeJam.Blog.AlwaysTurnLeft" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อถัดมา <a href="https://code.google.com/codejam/contest/32003/dashboard#s=p1">Always Turn Left</a><br />
        คือ สมมติว่าคุณมีหุ่นยนต์ตัวนึงเพื่อสำรวจเขาวงกต<br />
        หลักการของหุ่นยนต์ตัวนี้ง่ายมาก ถ้าเจอทางแยกจะเลี้ยวซ้ายเสมอ<br />
        โจทย์ต้องการให้คุณวาดแผนที่ออกมา<br />
        อ่านเพิ่มเติม <a href="https://code.google.com/codejam/contest/32003/dashboard#s=p1">ที่นี่</a><br />
        <br />
        โจทย์ข้อนี้หลักการคิดคือ<br />
        ระหว่างที่หุ่นยนต์ตัวนี้เดินไป เราก็แค่เก็บตำแหน่งและทิศทางของแต่ละจุด<br />
        แล้วก็เอามา plot เป็นแผนที่<br />
        <br />
        ก่อนอื่นเรามารู้จัก type ชื่อ direction กันก่อน<br />
        <pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">[&lt;Flags&gt;]
<span style="color:#569cd6;">type</span>&nbsp;Direction&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;None&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;North&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;South&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">2</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;West&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">4</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;East&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">8</span></pre>
    
        ด้านบนเป็นวิธีการเขียน <a href="http://msdn.microsoft.com/en-us/library/dd233216.aspx">enum</a> ของ f#<br />
        <br />
        แล้วก็ functions ต่างๆ ที่เกี่ยวกับทิศทาง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;turnLeft&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>North&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>West
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>South&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>East
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>West&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>South
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>East&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>North
 
<span style="color:#569cd6;">let</span>&nbsp;opposite&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">function</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>North&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>South
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>South&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>North
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>West&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>East&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>East&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>West&nbsp;
 
<span style="color:#569cd6;">let</span>&nbsp;turnRight&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;turnLeft&nbsp;<span style="color:#b4b4b4;">&gt;&gt;</span>&nbsp;opposite</pre>
        หันซ้าย และ ย้อนกลับ ค่อนข้างตรงตัว<br />
        ส่วนหันขวาคือการเอาหันซ้ายและย้อนกลับมาผสมกัน<br />
        <br />
        และ function เกี่ยวกับการเดินทาง<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;move&nbsp;(r,&nbsp;c)&nbsp;dir&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;dir&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>North&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;r&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>,&nbsp;c
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>South&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;r&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span>,&nbsp;c
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>West&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;r,&nbsp;c&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;<span style="color:#b5cea8;">1</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Direction<span style="color:#b4b4b4;">.</span>East&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;r,&nbsp;c&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;<span style="color:#b5cea8;">1</span></pre>
        อันนี้เป็นคำสั่งเลื่อน 1 ตำแหน่ง r และ c คือ ตำแหน่ง (rows และ columns)<br />
        <br />
        อีกคำสั่งยากหน่อยแต่ควรทำความเข้าใจ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;replay&nbsp;cmd&nbsp;states&nbsp;dir&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;cmd&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;[]&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;states,&nbsp;dir
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#d69d85;">&#39;L&#39;</span><span style="color:#b4b4b4;">::</span>cmd&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;replay&nbsp;cmd&nbsp;states&nbsp;(turnLeft&nbsp;dir)
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#d69d85;">&#39;R&#39;</span><span style="color:#b4b4b4;">::</span>cmd&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;replay&nbsp;cmd&nbsp;states&nbsp;(turnRight&nbsp;dir)
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#d69d85;">&#39;W&#39;</span><span style="color:#b4b4b4;">::</span>cmd&nbsp;<span style="color:#569cd6;">-&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newList&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;(point,&nbsp;wall)<span style="color:#b4b4b4;">::</span>tail&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;states
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newPoint&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;move&nbsp;point&nbsp;dir
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newState&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;newPoint,&nbsp;opposite&nbsp;dir
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;wall&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;Direction<span style="color:#b4b4b4;">.</span>None&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;newState<span style="color:#b4b4b4;">::</span>tail
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;head&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(point,&nbsp;wall&nbsp;<span style="color:#b4b4b4;">|||</span>&nbsp;dir)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;newState<span style="color:#b4b4b4;">::</span>head<span style="color:#b4b4b4;">::</span>tail
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;replay&nbsp;cmd&nbsp;newList&nbsp;dir</pre>
        คือ คำสั่ง replay บันทึกการเดินทาง<br />
        cmd เป็น list เก็บบันทึกการเดินทาง<br />
        states เป็น list เก็บตำแหน่ง และลักษณะของห้อง<br />
        dir เป็น direction เก็บทิศทางล่าสุด<br />
        <br />
        ถ้าดูจาก function ถ้า replay หมดทุกคำสั่ง [] ก็จะ return state กับ dir ออกไป<br />
        ถ้าสั่ง L หรือ R ก็แค่หันซ้ายและขวา แล้วทำคำสั่งถัดไป<br />
        ทีนี้ที่เยอะคือสั่ง W หลักๆ เช่น เรากำลังหันไปทางทิศเหนือ<br />
        เราก็กำหนดให้ ตำแหน่งที่เราอยู่ มีทางเดินไปทางทิศเหนือได้<br />
        และตำแหน่งถัดไป มีทางเดินมาจากทางทิศใต้ได้<br />
        <br />
        คราวนี้มาเริ่มกันเลย เริ่มจาก function หลัก<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;forward&nbsp;backward&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        forward คือ บันทึกการเดินทางขาไป<br />
        backward คือ บันทึกการเดินทางขากลับ<br />
        <br />
        เริ่มจากสั่ง replay เดินไปกลับ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;startPoint&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;[(<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>,&nbsp;<span style="color:#b5cea8;">0</span>),&nbsp;Direction<span style="color:#b4b4b4;">.</span>None]
<span style="color:#569cd6;">let</span>&nbsp;(point,&nbsp;_)<span style="color:#b4b4b4;">::</span>tail,&nbsp;dir&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;replay&nbsp;(List<span style="color:#b4b4b4;">.</span>ofSeq&nbsp;forward)&nbsp;startPoint&nbsp;Direction<span style="color:#b4b4b4;">.</span>South
 
<span style="color:#569cd6;">let</span>&nbsp;returnPoint&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(point,&nbsp;Direction<span style="color:#b4b4b4;">.</span>None)<span style="color:#b4b4b4;">::</span>tail
<span style="color:#569cd6;">let</span>&nbsp;_<span style="color:#b4b4b4;">::</span>tail2,&nbsp;_&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;replay&nbsp;(List<span style="color:#b4b4b4;">.</span>ofSeq&nbsp;backward)&nbsp;returnPoint&nbsp;(opposite&nbsp;dir)</pre>
        จุดเริ่มต้น startPoint คือ แถว -1 และเดินเข้าเขาวงกตจากทิศใต้เสมอ (โจทย์กำหนด)<br />
        แล้วก็เอาผลลัพธ์ของการ replay ครั้งแรกไปใส่ returnPoint เพื่อจะได้ทำการ replay ขากลับ<br />
        ได้ผลลัพธ์ tail2 คือ บันทึกตำแหน่งและลักษณะห้องในเขาวงกตทั้งหมด<br />
        <br />
        สุดท้ายคือการเอา บันทึกตำแหน่งมา plot เป็นแผนที่เขาวงกต<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;mergeWalls&nbsp;(key,&nbsp;list)&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;key,&nbsp;list&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>map&nbsp;snd
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>fold&nbsp;(<span style="color:#b4b4b4;">|||</span>)&nbsp;Direction<span style="color:#b4b4b4;">.</span>None
<span style="color:#569cd6;">let</span>&nbsp;hex&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;sprintf&nbsp;<span style="color:#d69d85;">&quot;%x&quot;</span>
<span style="color:#569cd6;">let</span>&nbsp;createRows&nbsp;(key,&nbsp;list)&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;list&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>sortBy&nbsp;fst
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>map&nbsp;(snd&nbsp;<span style="color:#b4b4b4;">&gt;&gt;</span>&nbsp;int&nbsp;<span style="color:#b4b4b4;">&gt;&gt;</span>&nbsp;hex)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;String<span style="color:#b4b4b4;">.</span>Concat
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;(<span style="color:#b4b4b4;">+</span>)&nbsp;<span style="color:#d69d85;">&quot;&#92;r&#92;n&quot;</span>
tail2&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>groupBy&nbsp;fst
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>map&nbsp;mergeWalls
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>groupBy&nbsp;(fst&nbsp;<span style="color:#b4b4b4;">&gt;&gt;</span>&nbsp;fst)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>sortBy&nbsp;fst
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;Seq<span style="color:#b4b4b4;">.</span>map&nbsp;createRows
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;String<span style="color:#b4b4b4;">.</span>Concat</pre>
        tail2 เป็น list เก็บตำแหน่งและลักษณะของห้องทั้งหมด<br />
        Seq.groupBy fst คือ การ group ตามตำแหน่ง<br />
        Seq.map mergeWalls คือ การเอาลักษณะของห้องมารวมกัน<br />
        ห้องๆ นึงเราอาจเดินผ่านหลายรอบ เช่นครั้งแรกเดินเข้ามาทางทิศตะวันตก แล้วไปทิศเหนือ<br />
        ผ่านมาอีกครั้งอาจจะมาจากทางทิศเหนือ ไปทางทิศตะวันออก<br />
        เมื่อเราเอาข้อมูลมารวมกัน ก็จะรู้ว่าห้องนี้ มีทางเดินทางทิศตะวันตก ทิศเหนือ และทิศตะวันออก<br />
        <br />
        Seq.groupBy (fst &gt;&gt; fst) คือ จัดกลุ่มตาม row<br />
        Seq.sortBy fst คือเรียงตาม row คือ row แรกให้อยู่ด้านบน<br />
        <br />
        คราวนี้คือ Seq.map createRows คือ การพิมพ์ห้องต่างๆ ในแต่ละ row<br />
        createRows คือ คำสั่งแปลงลักษณะห้องต่างๆ เป็น hex (โจทย์กำหนด)<br />
        แล้วเอา hex ของทั้งแถวมาเชื่อมกัน<br />
        <br />
        สุดท้าย String.Concat คือการเอา hex แต่ละแถวมาเชื่อมกัน<br />
        จะได้ออกมาเป็นแผนที่เขาวงกต<br />
        <br />
        จบ</div>
    </form>
</body>
</html>
