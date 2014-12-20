let sudoku brd = let diff i j = i/9<>j/9 && i%9<>j%9 && (i/27)*3 + (i%9)/3 <> (j/27)*3 + (j%9)/3
                 let rec solve ans unk =
                     match unk |> List.sortBy (snd >> List.length) with
                     | [] -> Seq.singleton ans
                     | (i,xs)::ts -> let filter v (j,ys) = j, List.filter (fun v2 -> diff i j || v2<>v) ys
                                     xs |> Seq.collect (fun n -> solve ((i,n)::ans) (List.map (filter n) ts))
                 let unk = brd |> Seq.mapi (fun i v -> i, if v > 0 then [v] else [1..9]) |> Seq.toList
                 solve [] unk |> Seq.head |> Seq.sort |> Seq.map snd |> Seq.toArray


[<EntryPoint>]
let main argv = 
    let __ = 0
    let ans = sudoku [|__;__;__;__;__;__;__;__;__;
                       __;__;__;__;__; 3;__; 8; 5;
                       __;__; 1;__; 2;__;__;__;__;
                       __;__;__; 5;__; 7;__;__;__;
                       __;__; 4;__;__;__; 1;__;__;
                       __; 9;__;__;__;__;__;__;__;
                        5;__;__;__;__;__;__; 7; 3;
                       __;__; 2;__; 1;__;__;__;__;
                       __;__;__;__; 4;__;__;__; 9|]
    for i in [0..9..72] do
        printfn "%A" ans.[i..i+8]
    0
