open System
open System.Security.Cryptography

let genUUID7 () =
    let time = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds ()

    let embedUUID idx el =
        match idx with
        //embed the timestamp's bytes into the first 6 indices of the bytes
        | idx when idx < 6 ->
            let tsByte = (time >>> (40 - (8 * idx))) &&& 0xFF
            byte tsByte
            
        //embed the UUID version and variant in the 7th and 9th position
        | 6 -> (el &&& 0x0Fuy) ||| 0x70uy
        | 8 -> (el &&& 0x3Fuy) ||| 0x80uy

        //retain remaining random bytes
        | _ -> el

    //generate random bytes
    RandomNumberGenerator.GetBytes 16
    //use an indexed mapping function to replace specific indices in the byte array
    |> Array.mapi embedUUID

//convert the UUID byte array to a familiar hex encoded string
let uuidToString: byte array -> string =
    Array.map (sprintf "%02x")
    >> Array.toSeq
    >> String.concat ""

//main
genUUID7 () 
|> uuidToString 
|> printfn "%A"