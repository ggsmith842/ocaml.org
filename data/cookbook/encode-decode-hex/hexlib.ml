---
packages: [Hex, Cstruct]
discussion: |
  - **Using the Hex and Cstruct libraries to decode a hexidecimal string to an ascii string.
  - **Using the Hex library to convert an ascii string to a hexidecimal encoded message.
  - **Leverages the Hex and Cstruct libraries.
---

(* Decode a hex string  *)
let decode_hex_string (hex_string : string) : string =
  let byte_string = Hex.to_cstruct (`Hex hex_string) in
  let decoded_string = Cstruct.to_string byte_string in
  decoded_string
;;

(* Encode a string to hex *)
let encode_to_hex (message : string) : string =
  Hex.of_string message
;;

(* Example *)
let secret_message = "48656c6c6f2c20576f726c6421"
let decrypted_message = decode_hex_string secret_message;;

(* Show the decrypted message *)
print_endline decrypted_message

(* Encrypt the message back to hexidecimal *)
let encoded_message = encode_to_hex secret_message;;

(* Show the hexidecimal encoded message *)
Hex.show encoded_message
