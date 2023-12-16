# apis

With the recent release of Bazel 7 and the preference for bzlmod dependency manangement, I've created a simple project that uses the current state of Bazel (v7-bzlmod), Go (1.21.3), Protobuf (v21.7), and gRPC (v1.48.1).
My goal is to have a simple app that shows how to use the latest technologies to generate protobuf and grpc Go files from proto files using GoogleApi (i.e. annotations.proto).
The project is very close to the goal, but I have an odd issue that I am hoping someone will know how to resolve.

## STATUS
At this time, everything is working except that when I try to generate Go files from protobuf files, Bazel is not able to find a dependency.  I have not been able to resolve this issue, yet.

Steps to reproduce:
1) bazel clean --expunge --async
2) bazel query "//..."
   //:gazelle
   //:gazelle-runner
   //proto/hello_world:hello_world_go_proto
   //proto/hello_world:hello_world_lib
   //proto/hello_world:hello_world_proto

3) Build the proto_library:
      bazel build //proto/hello_world:hello_world_proto
      SUCCESS:
        Created hello_world_proto-descriptor-set.proto.bin

4) Build the go_proto_library:
      bazel build //proto/hello_world:hello_world_go_proto
      FAILURE:
        The following file was successfully generated: hello_world.pb.go.
        The following error message was presented.  Bazel reports that a GoogleApis dependency was missing: "google.golang.org/genproto/googleapis/api/annotations"
   
(23:12:50) ERROR: /Users/mike/Go/src/github.com/abitofhelp/apis/proto/hello_world/BUILD.bazel:15:17: GoCompilePkg proto/hello_world/hello_world_go_proto.a failed: (Exit 1): builder failed: error executing GoCompilePkg command (from target //proto/hello_world:hello_world_go_proto) 
 .
 .
 .
compilepkg: missing strict dependencies:
        /private/var/tmp/_bazel_mike/8fa0853ec42280e0c909d3c4ea9a769c/sandbox/darwin-sandbox/348/execroot/_main/bazel-out/darwin_x86_64-fastbuild/bin/proto/hello_world/hello_world_go_proto_/github.com/abitofhelp/apis/proto/hello_world/hello_world.pb.go: 
import of "google.golang.org/genproto/googleapis/api/annotations"
No dependencies were provided.

