"""
Request = Request-Line ; Section 5.1  ->  Request-Line   = Method SP Request-URI SP HTTP-Version CRLF**
*(( general-header ; Section 4.5    -> message being transmitted, eg: Connection
| request-header ; Section 5.3      -> allow client to pass additional info about request, eg: accept-language, accept.charset etc
| entity-header ) CRLF) ; Section 7.1  -> define information aboud entitybody or if none is present eg, Allow; Contetnt-encoding, content-type, range
CRLF      --> carraige return line feed
[ message-body ] --> can be empty, else carries body of request


Request-Line   = Method SP Request-URI SP HTTP-Version CRLF
Method: GET, POST etc
Request-uri: unifromresourse identifiers formatted strings which identfy via name, location -> a resource
HTTP-version: HTTP 1.1 etc
"""

defmodule HTTP do

  #parse an http request
  #return tuple consisting of parsed result and rest of string
  def parse_request(r0) do
    {request, r1} = request_line(r0)
    {headers, r2} = headers(r1)
    {body, _} = message_body(r2)
    {request, headers, body}
  end

  #string represented as lists of integer values.
  #?C gives ascii value of character,
  #note: 32 = space in ascii
  def request_line([?G, ?E, ?T, 32 | r0]) do
    {uri, r1} = request_uri(r0)
    {ver, r2} = http_version(r1)
    [13, 10|r3] = r2  #\r\n
    {{:get, uri, ver}, r3}
  end

  #we've reached space, ie end of URI
  def request_uri([32 | r0]) do {[], r0} end
  #uri represented as char-integer calues in array
  def request_uri([c|r0]) do
    {rest, r1} = request_uri(r0)
    #returns {[list of chars making uri], rest of http request}
    {[c | rest], r1}

  end

  #can only be 1.1 or 1.0
  def http_version([?H, ?T, ?T, ?P, ?/, ?1, ?., ?1 | r0]) do
    {:v11, r0}
  end

  def http_version([?H, ?T, ?T, ?P, ?/, ?1, ?., ?0 | r0]) do
    {:v10, r0}
  end

  #we are done parsing headers
  def headers([13, 10 | r0]) do {[], r0} end
  def headers(r0) do
    {header, r1} = header(r0) #returns a header
    {rest, r2} = headers(r1)  #check the rest of headers
    {[header|rest], r2}
  end

  #we are done parsing this header, newline
  def header([13, 10 | r0]) do {[], r0} end
  def header([c|r0]) do
    {rest, r1} = header(r0)
    #list of chars making one header, and rest of headers
    {[c|rest], r1}
  end

  #simplification: treat rest of string as the body part
  def message_body(r) do {r, []} end

  #return HTTP/1.1 200 OK
  def ok(body) do
    "HTTP 1/1. 200 OK\r\n\r\n #{body}"
  end

  def get(uri) do
    "GET #{uri} HTTP/1.1\r\n\r\n"
  end

  
end
