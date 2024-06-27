---
packages:
  - name: "lwt"
    tested_version: "5.7.0"
    used_libraries:
      - lwt
  - name: "cohttp"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp
  - name: "cohttp-lwt-unix"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp-lwt-unix
  - name: "tls-lwt"
    tested_version: "0.17.5"
    used_libraries:
      - tls-lwt
discussion: |
  - **REST API Operations - POST:** A `POST` operation creates a *new* resouce. Example: Add data to a database
  - **SSL-TLS Exception:** Running this example may result in an error: `Exception: Failure No SSL or TLS support compiled into Conduit`. To resolve this issue you can run `opam install tls-lwt`
  - **Reference:** The code below uses the GitHub REST API as an example. Please review the documentation here: [github.com/restap/issues/comments](https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#create-an-issue-comment)
---

open Lwt
open Cohttp
open Cohttp_lwt_unix

(* Create POST request message payload. This can vary from API to API so be
sure to review the API's documentation on what it expects to receive*)
let message_body = ref "{\"body\":\"This is a good issue to work on!\"}"

(* 

`request_body` contains our API endpoint `uri`. This example uses the GitHub issue comments
API endpoint. You will need to fill in `<username>`, `<respository>`, and `<issue number>` with 
your own information from GitHub.

Define headers using `Header.init` and `Header.add`. Since we are using Bearer Token authentication, we need to add the `Authorization` header, which has the form `Bearer <your token>`. 
  
Ensure you always keep your token secret. You can refer to the `read-environment-variable` section in the cookbook for one way to protect your token.

Initialise the `body` to contain the JSON formatted text defined earlier in `message_body`. We tell the client we are making a `POST` call and pass the headers and body. 
`Client.call` performs the operation and returns a  `response` and a `code` to let us know if our call worked as expected (i.e., 201 means the call created a resource).  

*)
let request_body =
  let uri =
    Uri.of_string
      "https://api.github.com/repos/<username>/<repository>/issues/<issue number>/comments"
  in
  let headers =
    Header.init ()
    |> fun h ->
    Header.add h "Accept" "application/vnd.github+json"
    |> fun h ->
    Header.add h "Authorization" "Bearer <your token goes here>"
    |> fun h -> Header.add h "X-GitHub-Api-Version" "2022-11-28"
  in
  let body = Cohttp_lwt.Body.of_string !message_body in
  Client.call ~headers ~body `POST uri
  >>= fun (response, body) ->
  let code = response |> Response.status |> Code.code_of_status in
  body |> Cohttp_lwt.Body.to_string >|= fun body -> code, body


(* `Lwt_main.run` executes our call defined in the `request_body` and then
  we print the `response_code` and the `response_body` *)
let () =
  let response_code, response_body = Lwt_main.run request_body in
  Printf.printf "Respose code: %d\n" response_code;
  Printf.printf "Response body: %s\n" response_body
