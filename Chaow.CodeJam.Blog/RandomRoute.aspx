<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RandomRoute.aspx.cs" Inherits="Chaow.CodeJam.Blog.RandomRoute" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        ข้อถัดมา <a href="https://code.google.com/codejam/contest/32014/dashboard#s=p2">Random Route</a><br />
        ข้อนี้จะให้รายการถนนมา และเวลาในการผ่านถนนเส้นนี้<br />
        โดยคุณก็ไม่รู้จุดหมาย คุณเลยสุ่มเลือกให้ทุกจุดหมายมีโอกาสเท่ากัน<br />
        และคุณก็ไม่รู้จะใช้ถนนเส้นไหน คุณก็สุ่มเลือกถนนที่สั้นที่สุด ถ้ามีหลายเส้น ทุกเส้นมีโอกาสเท่ากัน<br />
        อ่านเพิ่มเติมได้ <a href="https://code.google.com/codejam/contest/32014/dashboard#s=p2">ที่นี่</a><br />
        <br />
        ข้อนี้อาจจะต้องใช้ทักษะในการใช้ <a href="http://msdn.microsoft.com/en-us/library/dd233209.aspx">Sequence</a> ของ F# อยู่สักหน่อย<br />
        <br />
        เริ่มจาก type ของถนน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">type</span>&nbsp;<span style="color:#4ec9b0;">Road</span>&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;{&nbsp;id<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">int</span>;&nbsp;origin<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">string</span>;&nbsp;dest<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">string</span>;&nbsp;distant<span style="color:#b4b4b4;">:</span><span style="color:#4ec9b0;">int</span>&nbsp;}</pre>
        id คือหมายเลขถนน<br />
        origin กับ dest คือ ชื่อเมืองต้นทาง ปลายทาง<br />
        และ distant คือ ระยะทาง<br />
        <br />
        เริ่มกันเลย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;solve&nbsp;start&nbsp;roads&nbsp;<span style="color:#b4b4b4;">=</span></pre>
        start ชื่อชื่อเมืองเริ่มต้น<br />
        roads ชื่อ sequence ของถนน (Road)<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;<span style="color:#569cd6;">rec</span>&nbsp;explore&nbsp;ways&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;newWays&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">seq</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;way&nbsp;<span style="color:#569cd6;">in</span>&nbsp;ways&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;road&nbsp;<span style="color:#569cd6;">in</span>&nbsp;roads&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;head::tails&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;way
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;road<span style="color:#b4b4b4;">.</span>origin&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;head<span style="color:#b4b4b4;">.</span>dest&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>forall&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;it&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;it<span style="color:#b4b4b4;">.</span>origin&nbsp;<span style="color:#b4b4b4;">&lt;&gt;</span>&nbsp;road<span style="color:#b4b4b4;">.</span>dest)&nbsp;way&nbsp;<span style="color:#569cd6;">then</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">yield</span>&nbsp;road::way
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">if</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>isEmpty&nbsp;newWays
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">then</span>&nbsp;ways
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">else</span>&nbsp;explore&nbsp;newWays&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>append&nbsp;ways&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache</pre>
        คำสั่ง explore คำสั่งนี้จะต่อถนนไปเรื่อยๆ เช่น<br />
        เริ่มแรกอาจเป็น { กรุงเทพฯ-สมุทรสาคร }<br />
        พอ explore ครั้งนึงก็จะเป็น { กรุงเทพฯ-สมุทรสาคร; กรุงเทพฯ-สมุทรสาคร-เพชรบุรี }<br />
        คือ มันจะเติมเส้นทางไปเรื่อยๆ จนไม่เจอทางใหม่ๆ ถึงจะหยุด<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;destinations&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;roads&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>filter&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;it&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;it<span style="color:#b4b4b4;">.</span>origin&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;start)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#4ec9b0;">List</span><span style="color:#b4b4b4;">.</span>replicate&nbsp;<span style="color:#b5cea8;">1</span>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;explore
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>groupBy&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;(head::tails)&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;head<span style="color:#b4b4b4;">.</span>dest)</pre>
        ถัดมาก็จัดกลุ่มตามจุดหมาย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;destScore&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">1.0</span>&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;float&nbsp;(<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>length&nbsp;destinations)</pre>
        และเนื่องจากเราจะสุ่มให้ทุกจุดหมายมีโอกาสเท่ากัน<br />
        เราก็แค่หารตามจำนวนจุดหมาย<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;collectFn&nbsp;ways&nbsp;<span style="color:#b4b4b4;">=</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;shortestWays&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;ways&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>groupBy&nbsp;(<span style="color:#4ec9b0;">List</span><span style="color:#b4b4b4;">.</span>sumBy&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;it&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;it<span style="color:#b4b4b4;">.</span>distant))
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>minBy&nbsp;fst
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;snd
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>cache
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">let</span>&nbsp;wayScore&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#b5cea8;">1.0</span>&nbsp;<span style="color:#b4b4b4;">/</span>&nbsp;float&nbsp;(<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>length&nbsp;shortestWays)
&nbsp;&nbsp;&nbsp;&nbsp;shortestWays&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>collect&nbsp;id
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;it&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;it<span style="color:#b4b4b4;">.</span>id,&nbsp;destScore&nbsp;<span style="color:#b4b4b4;">*</span>&nbsp;wayScore)</pre>
        ถัดมาเป็นคำสั่งหาโอกาสของถนนต่างๆ<br />
        เริ่มจากหาถนนที่สั้นที่สุด<br />
        และถ้าเส้นทางที่สั้นที่สุดมีหลายเส้น เราให้โอกาสเท่าๆ กัน<br />
        เราเลยหาโอกาสการใช้ถนน ด้วยการหารด้วยจำนวนเส้นทางที่สั้นที่สุด<br />
        เสร็จแล้วก็เอาโอกาสของจุดหมาย คูณกันโอกาสของเส้นทาง กลายเป็นโอกาสการใช้ถนน<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;probs&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;<span style="color:#569cd6;">query</span>&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;_,&nbsp;ways&nbsp;<span style="color:#569cd6;">in</span>&nbsp;destinations&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">for</span>&nbsp;id,&nbsp;score&nbsp;<span style="color:#569cd6;">in</span>&nbsp;collectFn&nbsp;ways&nbsp;<span style="color:#569cd6;">do</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">groupValBy</span>&nbsp;score&nbsp;id&nbsp;<span style="color:#569cd6;">into</span>&nbsp;g
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#569cd6;">select</span>&nbsp;(g<span style="color:#b4b4b4;">.</span>Key,&nbsp;g<span style="color:#b4b4b4;">.</span>Sum())
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Map</span><span style="color:#b4b4b4;">.</span>ofSeq</pre>
        สุดท้ายแล้วกันการหาโอกาสของการใช้ถนนแต่ละเส้น<br />
        เราเอาเส้นทางต่างๆ ของแต่ละจุดหมายไปโยนใส่ collectFn ด้านบน<br />
        แล้วจัดกลุ่มตามเลขถนน และรวมโอกาสเข้าด้วยกัน<br />
        ด้านบนใช้ feature ของ F# เรียกว่า <a href="http://msdn.microsoft.com/en-us/library/hh225374.aspx">query expression</a><br />
        ซึ่งทำอะไรได้มากกว่า linq มาก<br />
        <br />
        สุดท้าย คืนค่า<pre style="font-family: Consolas; font-size: 19; color: gainsboro; background: #1e1e1e;"><span style="color:#569cd6;">let</span>&nbsp;ans&nbsp;<span style="color:#b4b4b4;">=</span>&nbsp;roads&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;road&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;probs<span style="color:#b4b4b4;">.</span>TryFind(road<span style="color:#b4b4b4;">.</span>id))
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;prob&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;<span style="color:#569cd6;">if</span>&nbsp;prob<span style="color:#b4b4b4;">.</span>IsNone&nbsp;<span style="color:#569cd6;">then</span>&nbsp;<span style="color:#b5cea8;">0.0</span>&nbsp;<span style="color:#569cd6;">else</span>&nbsp;prob<span style="color:#b4b4b4;">.</span>Value)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#b4b4b4;">|&gt;</span>&nbsp;<span style="color:#4ec9b0;">Seq</span><span style="color:#b4b4b4;">.</span>map&nbsp;(<span style="color:#569cd6;">fun</span>&nbsp;prob&nbsp;<span style="color:#569cd6;">-&gt;</span>&nbsp;sprintf&nbsp;<span style="color:#d69d85;">&quot;%.7f&quot;</span>&nbsp;prob)
<span style="color:#4ec9b0;">String</span><span style="color:#b4b4b4;">.</span>Join(<span style="color:#d69d85;">&quot;&nbsp;&quot;</span>,&nbsp;ans)</pre>
        โดยการ loop ทุกๆ ถนน แล้วไปหาใน probs ด้านบน<br />
        หากไม่เจอก็เป็น 0<br />
        <br />
        จบ</div>
    </form>
</body>
</html>
