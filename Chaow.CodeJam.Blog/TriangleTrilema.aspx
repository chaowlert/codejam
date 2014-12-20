<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TriangleTrilema.aspx.cs" Inherits="Chaow.CodeJam.Blog.TriangleTrilema" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อต่อมา <a href="https://code.google.com/codejam/contest/32014/dashboard">TriangleTrilema</a><br />
        ข้อนี้จะให้จุดมา 3 จุด แล้วให้เราบอกว่านี่เป็นสามเหลี่ยมประเภทไหน<br />
        โดยต้องบอกว่าเป็นสามเหลี่ยมด้านเท่า (Equilateral) สามเหลี่ยมหน้าจั่ว (Isosceles) หรือสามเหลี่ยมด้านไม่เท่า (Scalene)<br />
        และต้องบอกอีกว่า เป็นสามเหลี่ยมมุมป้าน (Obtuse) มุมฉาก (Right) หรือมุมแหลม (Acute)<br />
        และบางครั้งถ้าเป็นเส้นตรง หรือเป็นจุดเดียวก็ถือว่าไม่ใช่สามเหลี่ยม<br />
        อ่านเพิ่ม<a href="https://code.google.com/codejam/contest/32014/dashboard">ที่นี่</a><br />
        <br />
        เริ่มจากการหา ประเภทด้านของสามเหลี่ยม อันนี้เราอาจจะแค่วัดความยาวของแต่ละด้าน<br />
        แต่ตรงนี้มีกับดักนิดนึง ถ้าวัดความยาวตัวเลขอาจเป็น float เวลาเปรียบเทียบค่าอาจจะคลาดเคลื่อน<br />
        ดังนั้นแทนที่เราจะวัดความยาว เรามาหาพื้นที่สี่เหลี่ยมจตุรัสของแต่ละด้าน<br />
        สูตรการหาพื้นที่คือ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;area&nbsp;(x1,&nbsp;y1)&nbsp;(x2,&nbsp;y2)&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;deltaX&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;x1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;x2
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;deltaY&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;y1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;y2
&nbsp;&nbsp;&nbsp;&nbsp;(deltaX&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;deltaX)&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;(deltaY&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;deltaY)</pre>
        ถัดมา มาหาประเภทด้านของสามเหลี่ยม<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;typeSide&nbsp;areas&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;count&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;areas&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>distinct
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>length
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;count&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;equilateral&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">2</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;isosceles&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">3</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;scalene&quot;</span></pre>
        เราก็วัดขนาดพื้นที่ ถ้าเท่ากันหมด ก็ equilateral<br />
        ถ้าเท่ากัน 2 ด้านก็ isosceles<br />
        ถ้าไม่เท่ากันเลยก็ scalene<br />
        <br />
        คราวนี้เรามาวัดมุม<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;typeAngle&nbsp;areas&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;sorted&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Array</span><span style="color:#b4b4b4;">.</span>sort&nbsp;areas
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;compare&nbsp;(sorted<span style="color:#b4b4b4;">.</span>[<span style="color:#b5cea8;">0</span>]&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;sorted<span style="color:#b4b4b4;">.</span>[<span style="color:#b5cea8;">1</span>])&nbsp;sorted<span style="color:#b4b4b4;">.</span>[<span style="color:#b5cea8;">2</span>]&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;obtuse&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;right&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">1</span>&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;acute&quot;</span></pre>
        ถ้าเป็นมุมฉากก็ง่ายมาก เรารู้ว่าพื้นที่ด้าน A + B = C เสมอ (right)<br />
        จริงๆ คิดต่อก็ไม่ยาก ถ้า A + B &gt; C แปลว่า C มีพื้นที่แคบ จึงเป็นสามเหลี่ยมมุมแหลม (acute)<br />
        ถ้า A + B &lt; C แปลว่า C มีพื้นที่กว้าง จึงเป็นสามเหลี่ยมมุมป้าน (obtuse)<br />
        <br />
        ถัดมา เรามาหาว่าถ้าสามเหลี่ยมอยู่ระนาบเดียวกันหมด ก็ไม่ใช่สามเหลี่ยม<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;(|Collinear|Triangle|)&nbsp;((x1,&nbsp;y1),&nbsp;(x2,&nbsp;y2),&nbsp;(x3,&nbsp;y3))&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;(x1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;x2)&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;(y1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;y3)&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(x1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;x3)&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;(y1&nbsp;<span style="color:#b4b4b4;">-</span>&nbsp;y2)&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;Collinear
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;Triangle</pre>
        ด้านบนเป็น feature ของ f# ชื่อว่า <a href="http://msdn.microsoft.com/en-us/library/dd233248.aspx">Active Patterns</a><br />
        วิธีการหาก็ใช้สูตรหาความชัน ถ้าความชันเท่ากันก็ถือว่าเป็นระนาบเดียวกัน<br />
        ที่จริงสูตรหาความชันต้องเป็นหาร (x1 - x2) / (x1 - x3) = (y1 - y2) / (y1 - y3)<br />
        แต่เพียงแค่เอามาคูณสลับ เพื่อไม่อยากให้ type เป็น float<br />
        <br />
        เรามาเริ่มคำนวนกันเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;p1&nbsp;p2&nbsp;p3&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;p1,&nbsp;p2,&nbsp;p3&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Collinear&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#d69d85;">&quot;not&nbsp;a&nbsp;triangle&quot;</span>
&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;Triangle&nbsp;&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;areas&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;[|&nbsp;area&nbsp;p1&nbsp;p2;&nbsp;area&nbsp;p2&nbsp;p3;&nbsp;area&nbsp;p3&nbsp;p1&nbsp;|]
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sprintf&nbsp;<span style="color:#d69d85;">&quot;%s&nbsp;%s&nbsp;triangle&quot;</span>&nbsp;(typeSide&nbsp;areas)&nbsp;(typeAngle&nbsp;areas)</pre>
        โดย p1 = (x1, y1), p2 = (x2, y2), p3 = (x3, y3)<br />
        เข้าสูตรต่างๆ ด้านบนก็ได้ผลลัพธ์ออกมา<br />
        <br />
        จบ</div>
    </form>
</body>
</html>
