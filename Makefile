# Makefile
# Uncomment to use version from the command in the Makefile.
#include scripts/release.env
#export

# Uncomment to use GIT id values as the version.
VERSION=$(shell git describe --always)

PROJECT_NAME=falcon
CLIENT_DIR=github.com/ingios/$(PROJECT_NAME)
MODULE_NAME=$(CLIENT_DIR)/v5
PROJECT_DIR=$(GOPATH)/src/$(CLIENT_DIR)

BZL_CMD=bazel
BAZEL_BUILD_OPTS:=--action_env=VERSION=$(VERSION)
DOCKER_CMD=docker
DOCKER_COMPOSE_CMD=docker-compose
GO_CMD=$(BZL_CMD) run @io_bazel_rules_go//go
DOCKER_DIR=$(SERVICE_DIR)/project
INGIOS_CONTAINER_REGISTRY?=d3falcon.azurecr.io
PKG_DIR=$(PROJECT_DIR)/pkg
SERVICE_DIR=$(PROJECT_DIR)/service
CMD_DIR=$(PROJECT_DIR)/cmd

# LIBRARIES/PACKAGES
ALERT_LIB_DIR=$(PKG_DIR)/alert
ALERT_LIB_WORKSPACE=//pkg/alert
ALERT_LIB_TARGET=//pkg/alert:alert

CSCLIBRARY_LIB_DIR=$(PKG_DIR)/csclibrary
CSCLIBRARY_LIB_WORKSPACE=//pkg/csclibrary
CSCLIBRARY_LIB_TARGET=//pkg/csclibrary:csclibrary

GOLIBRARY_LIB_DIR=$(PKG_DIR)/golibrary
GOLIBRARY_LIB_WORKSPACE=//pkg/golibrary
GOLIBRARY_LIB_TARGET=//pkg/golibrary:golibrary

# COMMAND LINE ADMIN APPS
COMMITTER_CMD_TARGET=//cmd/committer:committer
COMMITTER_CMD_DIR=$(CMD_DIR)/committer
COMMITTER_CMD_NAME=committer
COMMITTER_CMD_WORKSPACE=//cmd/committer

# FALCON'S BACKEND SERVICES
BLOB_PROXY_TARGET=//service/blob/proxy:blob_proxy
BLOB_SERVER_TARGET=//service/blob/server:blob_server
BLOB_SERVICE_DIR=$(SERVICE_DIR)/blob
BLOB_SERVICE_NAME=blob-service
BLOB_SERVICE_PROXY_NAME=$(BLOB_SERVICE_NAME)-proxy
BLOB_SERVICE_WORKSPACE=//service/blob

PROJECT_PROXY_TARGET=//service/project/proxy:project_proxy
PROJECT_SERVER_TARGET=//service/project/server:project_server
PROJECT_SERVICE_DIR=$(SERVICE_DIR)/project
PROJECT_SERVICE_NAME=project-service
PROJECT_SERVICE_PROXY_NAME=$(PROJECT_SERVICE_NAME)-proxy
PROJECT_SERVICE_WORKSPACE=//service/project

QUEUE_PROXY_TARGET=//service/queue/proxy:queue_proxy
QUEUE_SERVER_TARGET=//service/queue/server:queue_server
QUEUE_SERVICE_DIR=$(SERVICE_DIR)/queue
QUEUE_SERVICE_NAME=queue-service
QUEUE_SERVICE_PROXY_NAME=$(QUEUE_SERVICE_NAME)-proxy
QUEUE_SERVICE_WORKSPACE=//service/queue

RUN_PROXY_TARGET=//service/run/proxy:run_proxy
RUN_SERVER_TARGET=//service/run/server:run_server
RUN_SERVICE_DIR=$(SERVICE_DIR)/run
RUN_SERVICE_NAME=run-service
RUN_SERVICE_PROXY_NAME=$(RUN_SERVICE_NAME)-proxy
RUN_SERVICE_WORKSPACE=//service/run

SLIDERMAP_PROXY_TARGET=//service/slidermap/proxy:slidermap_proxy
SLIDERMAP_SERVER_TARGET=//service/slidermap/server:slidermap_server
SLIDERMAP_SERVICE_DIR=$(SERVICE_DIR)/slidermap
SLIDERMAP_SERVICE_NAME=slidermap-service
SLIDERMAP_SERVICE_PROXY_NAME=$(SLIDERMAP_SERVICE_NAME)-proxy
SLIDERMAP_SERVICE_WORKSPACE=//service/slidermap

TRACK_PROXY_TARGET=//service/track/proxy:track_proxy
TRACK_SERVER_TARGET=//service/track/server:track_server
TRACK_SERVICE_DIR=$(SERVICE_DIR)/track
TRACK_SERVICE_NAME=track-service
TRACK_SERVICE_PROXY_NAME=$(TRACK_SERVICE_NAME)-proxy
TRACK_SERVICE_WORKSPACE=//service/track

build_ALL:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //...

build_ALL_images: build_blob_server_oci_image build_blob_proxy_oci_image build_project_server_oci_image build_project_proxy_oci_image build_queue_server_oci_image build_queue_proxy_oci_image build_run_server_oci_image build_run_proxy_oci_image build_slidermap_server_oci_image build_slidermap_proxy_oci_image  build_track_server_oci_image build_track_proxy_oci_image

build_alert_lib:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(ALERT_LIB_TARGET)

build_blob_proxy:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(BLOB_PROXY_TARGET)

build_blob_server:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(BLOB_SERVER_TARGET)

build_committer:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(COMMITTER_CMD_TARGET)

build_ALL_PLATFORMS_committer:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(COMMITTER_CMD_TARGET) --platforms="@io_bazel_rules_go//go/toolchain:linux_amd64, @io_bazel_rules_go//go/toolchain:macos_amd64, @io_bazel_rules_go//go/toolchain:windows_amd64"

build_committer_linux:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(COMMITTER_CMD_TARGET) --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64

build_committer_mac:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(COMMITTER_CMD_TARGET) --platforms=@io_bazel_rules_go//go/toolchain:macos_amd64

build_committer_win:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(COMMITTER_CMD_TARGET) --platforms=@io_bazel_rules_go//go/toolchain:windows_amd64

build_csclibrary_lib:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(CSCLIBRARY_LIB_TARGET)

build_golibrary_lib:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(GOLIBRARY_LIB_TARGET)

build_project_proxy:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(PROJECT_PROXY_TARGET)

build_project_server:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(PROJECT_SERVER_TARGET)

build_queue_proxy:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(QUEUE_PROXY_TARGET)

build_queue_server:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(QUEUE_SERVER_TARGET)

build_run_proxy:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(RUN_PROXY_TARGET)

build_run_server:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(RUN_SERVER_TARGET)

build_slidermap_proxy:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(SLIDERMAP_PROXY_TARGET)

build_slidermap_server:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(SLIDERMAP_SERVER_TARGET)

build_track_proxy:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(TRACK_PROXY_TARGET)

build_track_server:
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) $(TRACK_SERVER_TARGET)

build_blob_proxy_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/blob/proxy:blob_proxy_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/blob/proxy:blob_proxy_tarball);

build_blob_server_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/blob/server:blob_server_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/blob/server:blob_server_tarball);

build_project_proxy_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	echo $(VERSION) && \
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/project/proxy:project_proxy_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/project/proxy:project_proxy_tarball);

build_project_server_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/project/server:project_server_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/project/server:project_server_tarball);
	
build_queue_proxy_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/queue/proxy:queue_proxy_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/queue/proxy:queue_proxy_tarball);

build_queue_server_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/queue/server:queue_server_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/queue/server:queue_server_tarball);
	
build_run_proxy_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/run/proxy:run_proxy_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/run/proxy:run_proxy_tarball);

build_run_server_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/run/server:run_server_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/run/server:run_server_tarball);
	
build_slidermap_proxy_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/slidermap/proxy:slidermap_proxy_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/slidermap/proxy:slidermap_proxy_tarball);

build_slidermap_server_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/slidermap/server:slidermap_server_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/slidermap/server:slidermap_server_tarball);
	
build_track_proxy_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/track/proxy:track_proxy_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/track/proxy:track_proxy_tarball);

build_track_server_oci_image:
	# Must be a linux/amd64 binary built for the OCI container.
	$(BZL_CMD) build $(BAZEL_BUILD_OPTS) //service/track/server:track_server_tarball && \
	$(DOCKER_CMD) load --input $(shell $(BZL_CMD) cquery --output=files //service/track/server:track_server_tarball);

buildifier_check:
	$(BZL_CMD) run //:buildifier.check

clean_bazel:
	# Removes bazel-created output, including all object files, and bazel metadata.
	pushd $(PROJECT_DIR) && \
	$(BZL_CMD) clean --async && \
	popd;

deep_clean_bazel:
	# Removes bazel-created output, including all object files, and bazel metadata.
	pushd $(PROJECT_DIR) && \
	$(BZL_CMD) clean --expunge --async && \
	popd;

clean_vendors:
	pushd $(PROJECT_DIR) && \
	find . -path '*/vendor*' -delete && \
	popd;

delete_images_for_version:
	# Determine the ID values for the images and delete them.
	docker rmi --force $$(docker images --format {{.Repository}}:{{.Tag}}@{{.ID}} |grep $(VERSION) |awk '{split($$0, array, "@"); print array[2]}' |sort -u |awk '{print $1}')

expand_golang_build:
	$(BZL_CMD) query $(GOLIBRARY_LIB_TARGET) --output=build

gazelle_generate_build_bazel:
	# This will generate new BUILD.bazel files for your project. You can run the same command
	# in the future to update existing BUILD.bazel files to include new source files or options.
	pushd $(PROJECT_DIR) && \
	$(BZL_CMD) run $(BAZEL_BUILD_OPTS) //:gazelle && \
    popd;

gazelle_update_deps:
	# Import repositories from go.mod and update Bazel's macro and rules.
	# After running update-repos, you might want to run bazel run //:gazelle again,
	# as the update-repos command can affect the output of a normal run of Gazelle.
	pushd $(PROJECT_DIR) && \
	$(BZL_CMD) run $(BAZEL_BUILD_OPTS) //:gazelle -- update-repos -from_file="go.mod" -to_macro="deps.bzl%go_dependencies" && \
	popd;
	
generate_csclibrary_deps_graph:
	pushd $(PROJECT_DIR) && \
	$(BZL_CMD) query --notool_deps --noimplicit_deps "deps(//pkg/csclibrary:csclibrary)" --output graph && \
	dot -Tsvg graph.dot > csclibrary_graph.svg && \
    popd;

go_mod_download:
	pushd $(PROJECT_DIR) && \
	$(GO_CMD) -- mod download && \
	popd;

go_mod_tidy:
	pushd $(PROJECT_DIR) && \
	$(GO_CMD) -- mod tidy && \
	popd;

go_mod_vendor:
	pushd $(PROJECT_DIR) && \
	$(GO_CMD) -- mod vendor -v && \
	popd;

go_mod_verify:
	## Verify that the go.sum file matches what was downloaded to prevent someone “git push — force” over a tag being used.
	pushd $(PROJECT_DIR) && \
	$(GO_CMD) -- mod verify && \
	popd;

go_targets:
	$(BZL_CMD) query "@io_bazel_rules_go//go:*"

list_ALL_targets:
	$(BZL_CMD) query "//..."

list_alias_targets:
	$(BZL_CMD) query "kind(alias, //...)"

list_ALL_images_for_version:
	docker images | grep $(VERSION) |sort |awk '{print $3}'

pub_blob_to_acr:
	@az acr login --name d3falcon
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_NAME)-linux-x86_64:latest"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_PROXY_NAME)-linux-x86_64:latest"

pub_project_to_acr:
	@az acr login --name d3falcon
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_NAME)-linux-x86_64:latest"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_PROXY_NAME)-linux-x86_64:latest"

pub_queue_to_acr:
	@az acr login --name d3falcon
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_NAME)-linux-x86_64:latest"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_PROXY_NAME)-linux-x86_64:latest"

pub_run_to_acr:
	@az acr login --name d3falcon
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_NAME)-linux-x86_64:latest"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_PROXY_NAME)-linux-x86_64:latest"

pub_slidermap_to_acr:
	@az acr login --name d3falcon
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_NAME)-linux-x86_64:latest"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_PROXY_NAME)-linux-x86_64:latest"

pub_track_to_acr:
	@az acr login --name d3falcon
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_NAME)-linux-x86_64:latest"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	docker push "$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_PROXY_NAME)-linux-x86_64:latest"

pub_ALL_to_acr: pub_blob_to_acr pub_project_to_acr pub_queue_to_acr pub_run_to_acr pub_slidermap_to_acr pub_track_to_acr

run_project_proxy_binary:
	# Must be a native binary build not an OCI container.
	$(BZL_CMD) run $(PROJECT_PROXY_TARGET)

set_golang_version:
	sed -E -i '.org' 's/go 1.21.3/go 1.21.4/g' "$(PROJECT_DIR)/go.mod" && rm "$(PROJECT_DIR)/go.mod.org" && \
	sed -E -i '.org' 's/go_sdk.download(version = "1.21.3")"/go_sdk.download(version = "1.21.4")/g' "$(PROJECT_DIR)/MODULE.bazel" && rm "$(PROJECT_DIR)/MODULE.bazel.org" ;

start_ALL_containers: build_ALL_images
	pushd $(PROJECT_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_ALL_containers:
	pushd $(PROJECT_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;

start_blob_and_proxy_containers: build_blob_server_oci_image build_blob_proxy_oci_image
	pushd $(BLOB_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_blob_and_proxy_containers:
	pushd $(BLOB_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;

start_project_and_proxy_containers: build_project_server_oci_image build_project_proxy_oci_image
	pushd $(PROJECT_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_project_and_proxy_containers:
	pushd $(PROJECT_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;

start_queue_and_proxy_containers: build_queue_server_oci_image build_queue_proxy_oci_image
	pushd $(QUEUE_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_queue_and_proxy_containers:
	pushd $(QUEUE_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;
	
start_run_and_proxy_containers: build_run_server_oci_image build_run_proxy_oci_image
	pushd $(RUN_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_run_and_proxy_containers:
	pushd $(RUN_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;

start_slidermap_and_proxy_containers: build_slidermap_server_oci_image build_slidermap_proxy_oci_image
	pushd $(SLIDERMAP_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_slidermap_and_proxy_containers:
	pushd $(SLIDERMAP_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;
	
start_track_and_proxy_containers: build_track_server_oci_image build_track_proxy_oci_image
	pushd $(TRACK_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) up && \
	popd;

stop_track_and_proxy_containers:
	pushd $(TRACK_SERVICE_DIR) && \
	$(DOCKER_COMPOSE_CMD) down && \
	popd;

## The generate_repos at the end of the command string is not an error.
## Verify the BUILD.bazel files that have been changed.  It is possible that duplicate targets were created.
# After running update-repos, you might want to run bazel run //:gazelle again, as the update-repos command
# can affect the output of a normal run of Gazelle.
sync_from_gomod: go_mod_download go_mod_tidy go_mod_verify gazelle_update_deps gazelle_generate_build_bazel

sync_from_gomod_force: go_mod_download go_mod_tidy go_mod_verify gazelle_generate_build_bazel gazelle_update_deps gazelle_generate_build_bazel

tag_for_ingios_blob:
	@docker tag "$(BLOB_SERVICE_NAME)-linux-x86_64:latest" 			"$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(BLOB_SERVICE_NAME)-linux-x86_64:latest" 			"$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_NAME)-linux-x86_64:latest"
	@docker tag "$(BLOB_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(BLOB_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(BLOB_SERVICE_PROXY_NAME)-linux-x86_64:latest"

tag_for_ingios_project:
	@docker tag "$(PROJECT_SERVICE_NAME)-linux-x86_64:latest" 			"$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(PROJECT_SERVICE_NAME)-linux-x86_64:latest" 			"$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_NAME)-linux-x86_64:latest"
	@docker tag "$(PROJECT_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(PROJECT_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(PROJECT_SERVICE_PROXY_NAME)-linux-x86_64:latest"

tag_for_ingios_queue:
	@docker tag "$(QUEUE_SERVICE_NAME)-linux-x86_64:latest" 		"$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(QUEUE_SERVICE_NAME)-linux-x86_64:latest" 		"$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_NAME)-linux-x86_64:latest"
	@docker tag "$(QUEUE_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(QUEUE_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(QUEUE_SERVICE_PROXY_NAME)-linux-x86_64:latest"

tag_for_ingios_run:
	@docker tag "$(RUN_SERVICE_NAME)-linux-x86_64:latest" 			"$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(RUN_SERVICE_NAME)-linux-x86_64:latest" 			"$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_NAME)-linux-x86_64:latest"
	@docker tag "$(RUN_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(RUN_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(RUN_SERVICE_PROXY_NAME)-linux-x86_64:latest"

tag_for_ingios_slidermap:
	@docker tag "$(SLIDERMAP_SERVICE_NAME)-linux-x86_64:latest" 		"$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(SLIDERMAP_SERVICE_NAME)-linux-x86_64:latest" 		"$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_NAME)-linux-x86_64:latest"
	@docker tag "$(SLIDERMAP_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(SLIDERMAP_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(SLIDERMAP_SERVICE_PROXY_NAME)-linux-x86_64:latest"

tag_for_ingios_track:
	@docker tag "$(TRACK_SERVICE_NAME)-linux-x86_64:latest" 		"$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(TRACK_SERVICE_NAME)-linux-x86_64:latest" 		"$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_NAME)-linux-x86_64:latest"
	@docker tag "$(TRACK_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_PROXY_NAME)-linux-x86_64:$(VERSION)"
	@docker tag "$(TRACK_SERVICE_PROXY_NAME)-linux-x86_64:latest" 	"$(INGIOS_CONTAINER_REGISTRY)/$(TRACK_SERVICE_PROXY_NAME)-linux-x86_64:latest"

tag_ALL_for_ingios: tag_for_ingios_blob tag_for_ingios_project tag_for_ingios_queue tag_for_ingios_run tag_for_ingios_slidermap tag_for_ingios_track

tidy: clean_bazel clean_vendors go_mod_tidy go_mod_vendor go_mod_verify

zap: deep_clean_bazel clean_vendors
	pushd $(PROJECT_DIR) && \
	find . -type f -name "go.sum" -delete && \
	go clean -modcache -cache && \
	make go_mod_download && \
	make go_mod_tidy && \
	make go_mod_vendor && \
	make go_mod_verify && \
	popd;

