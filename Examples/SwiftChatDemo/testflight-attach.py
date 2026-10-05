import time, json, urllib.request, sys
import jwt
kid="G93Z5D7Z5Z"; iss="affeb906-baa3-4dee-bd7f-575882da016d"
key=open("/Users/bls/.appstoreconnect/private_keys/AuthKey_G93Z5D7Z5Z.p8").read()
API="https://api.appstoreconnect.apple.com/v1"
def tok(): return jwt.encode({"iss":iss,"iat":int(time.time()),"exp":int(time.time())+1100,"aud":"appstoreconnect-v1"},key,algorithm="ES256",headers={"kid":kid})
def call(method,path,body=None):
    r=urllib.request.Request(API+path,data=json.dumps(body).encode() if body else None,method=method,headers={"Authorization":"Bearer "+tok(),"Content-Type":"application/json"})
    try:
        resp=urllib.request.urlopen(r); txt=resp.read()
        return json.loads(txt) if txt else {}
    except urllib.error.HTTPError as e: print(method,path,e.code,e.read()[:300],flush=True); return None
app="6819155007"; group="cd098808-fd16-41aa-b2c4-82824f3ccb85"
b=call("GET",f"/builds?filter[app]={app}&sort=-uploadedDate&limit=1")
if not b or not b["data"]: print("no build yet",flush=True); sys.exit(2)
build=b["data"][0]; bid=build["id"]; st=build["attributes"]["processingState"]
print("build",bid,"version",build["attributes"]["version"],"state",st,flush=True)
if st!="VALID": sys.exit(2)
loc=call("GET",f"/builds/{bid}/betaBuildLocalizations")
if loc and loc["data"]:
    call("PATCH",f"/betaBuildLocalizations/{loc['data'][0]['id']}",{"data":{"type":"betaBuildLocalizations","id":loc['data'][0]['id'],"attributes":{"whatsNew":"Seven example screens built on Swift Chat 1.0.6."}}})
else:
    call("POST","/betaBuildLocalizations",{"data":{"type":"betaBuildLocalizations","attributes":{"locale":"en-US","whatsNew":"Seven example screens built on Swift Chat 1.0.6."},"relationships":{"build":{"data":{"type":"builds","id":bid}}}}})
call("PATCH",f"/builds/{bid}",{"data":{"type":"builds","id":bid,"attributes":{"usesNonExemptEncryption":False}}})
sub=call("POST","/betaAppReviewSubmissions",{"data":{"type":"betaAppReviewSubmissions","relationships":{"build":{"data":{"type":"builds","id":bid}}}}})
print("review submission",sub and sub["data"]["attributes"]["betaReviewState"],flush=True)
att=call("POST",f"/betaGroups/{group}/relationships/builds",{"data":[{"type":"builds","id":bid}]})
print("attached to Public group" if att is not None else "attach failed",flush=True)
ext=call("GET",f"/builds/{bid}?fields[builds]=processingState,expired")
print("done; public link https://testflight.apple.com/join/57bKq9jd",flush=True)
