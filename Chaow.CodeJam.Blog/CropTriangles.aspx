<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CropTriangles.aspx.cs" Inherits="Chaow.CodeJam.Blog.CropTriangles" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        หลังจากคุณดู Discovery คุณก็อยากจะสร้าง Crop Circles บ้าง<br />
        แต่ระดับคุณ คุณจะสร้าง Crop Triangles แทน<br />
        และ Triangle ของคุณต้องไม่ธรรมดา<br />
        มุมต่างๆ ของสามเหลี่ยม ต้องอยู่บนจุดตัดบน Grid<br />
        ไม่พอ จุดศูนย์กลางของสามเหลี่ยมจะต้องอยู่บนจุดตัดบน Grid ด้วย<br />
        <br />
        สูตรการหาจุดศูนย์กลางคือ (x<sub>1</sub> + x<sub>2</sub> + x<sub>3</sub>) / 3, (y<sub>1</sub> + y<sub>2</sub> + y<sub>3</sub>) /3<br />
        <br />
        โจทย์จะมีสูตรให้สร้างจุดต่างๆ บน Grid<br />
        แล้วให้หาว่าเราสามารถสร้าง Crop Triangles ได้กี่แบบ<br />
        อ่านต่อ <a href="https://code.google.com/codejam/contest/32017/dashboard">ที่นี่</a><br />
        <br />
        เนื่องจาก large dataset สามารถสร้างจุดได้ถึง 100,000 จุด<br />
        เราจึงไม่สามารถใช้วิธี brute force ได้ ซึ่งจะต้องหาทั้งหมด 100,000! วิธี<br />
        <br />
        แต่จริงๆ พอจะมีทางลัด ถ้า (x<sub>1</sub> + x<sub>2</sub> + x<sub>3</sub>) / 3 เป็นจุดตัดบน grid
        <br />
        หมายความว่า x<sub>1</sub> + x<sub>2</sub> + x<sub>3</sub> หาร 3 ลงตัว<br />
        ซึ่งก็หมายความว่า x<sub>1</sub> mod 3 + x<sub>2</sub> mod 3 + x<sub>3</sub> mod 3 หาร 3 ลงตัว<br />
        <br />
        เริ่มเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;n&nbsp;A&nbsp;B&nbsp;C&nbsp;D&nbsp;x0&nbsp;y0&nbsp;M&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;unfoldFn&nbsp;(n,&nbsp;(x,&nbsp;y))&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">match</span>&nbsp;n&nbsp;<span style="color:#569cd6;">with</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;None
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;n&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">let</span>&nbsp;xN&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(A<span style="color:#b4b4b4;">*</span>x&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;B)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;M
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;yN&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;(C<span style="color:#b4b4b4;">*</span>y&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;D)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;M
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Some((x,&nbsp;y),&nbsp;(n<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1</span>,&nbsp;(xN,&nbsp;yN)))
 
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;trees&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>unfold&nbsp;unfoldFn&nbsp;(n,&nbsp;(x0,&nbsp;y0))</pre>
        n A B C D x0 y0 M เป็น input ที่โจทย์กำหนด<br />
        unfoldFn ก็เป็น function ที่โจทย์กำหนด เพื่อสร้างจุดต่างๆ<br />
        ส่วน trees คือจุดต่างๆ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;buckets&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;trees&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>groupBy&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(x,&nbsp;y)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;(int&nbsp;x&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">3</span>)<span style="color:#b4b4b4;">*</span><span style="color:#b5cea8;">3</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;(int&nbsp;y&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">3</span>))
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(key,&nbsp;g)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;key,&nbsp;g<span style="color:#b4b4b4;">.</span>LongCount())
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sortBy&nbsp;fst
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache</pre>
        ทีนี้ก็จัดกลุ่มเป็น 9 กลุ่ม (x mod 3) ตัดกับ (y mod 3)<br />
        แล้วก็นับจำนวนในกลุ่ม<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;sameBucketCount&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;buckets&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(key,&nbsp;cnt)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;cnt&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;(cnt<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">1L</span>)&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;(cnt<span style="color:#b4b4b4;">-</span><span style="color:#b5cea8;">2L</span>)&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;<span style="color:#b5cea8;">6L</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sum</pre>
        ถ้าเป็นกลุ่มเดียวกัน ก็แปลว่าหารลงตัวแน่นอน<br />
        เรื่องการหาจำนวนในกลุ่ม ใช้สูตร <a href="http://en.wikipedia.org/wiki/Combination">combinatorics</a><br />
        หยิบ 3 จาก cnt ตัว<br />
        <br />
        อีกแบบคือ คนละกลุ่มหมด แต่หาร 3 ลงตัว<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;diffBucketCount&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;key1,cnt1&nbsp;<span style="color:#569cd6;">in</span>&nbsp;buckets&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;key2,cnt2&nbsp;<span style="color:#569cd6;">in</span>&nbsp;buckets&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;key1&nbsp;<span style="color:#b4b4b4;">&lt;</span>&nbsp;key2&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;key3,cnt3&nbsp;<span style="color:#569cd6;">in</span>&nbsp;buckets&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;key2&nbsp;<span style="color:#b4b4b4;">&lt;</span>&nbsp;key3&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;(key1<span style="color:#b4b4b4;">+</span>key2<span style="color:#b4b4b4;">+</span>key3)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">3</span>&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;(key1<span style="color:#b4b4b4;">/</span><span style="color:#b5cea8;">3</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;key2<span style="color:#b4b4b4;">/</span><span style="color:#b5cea8;">3</span>&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;key3<span style="color:#b4b4b4;">/</span><span style="color:#b5cea8;">3</span>)&nbsp;<span style="color:#b4b4b4;">%</span>&nbsp;<span style="color:#b5cea8;">3</span>&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">0</span>&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;cnt1&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;cnt2&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;cnt3
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>sum</pre>
        คือ ถ้ามาจากคนละกลุ่มหมดเลย<br />
        และทั้งแกน x และ y หาร 3 ลงตัว<br />
        ก็เอาจำนวนมาคูณกันได้เลย<br />
        <br />
        จบแล้วครับ ได้คำตอบ<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;">sameBucketCount&nbsp;<span style="color:#b4b4b4;">+</span>&nbsp;diffBucketCount&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;string</pre>
        จบ<br />
    
    </div>
    </form>
</body>
</html>
