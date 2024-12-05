NAME = ENV.fetch("BOT_NAME")
VERSION = $(shell git describe --dirty --tags --long --always)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
REGISTRY_USER = dmitrytrager

deploy-production:
	@if [[ $(BRANCH) != "master" ]]; then echo "You should be on master branch" && exit 1; fi
	@if [[ $$(git status --porcelain) ]]; then echo "You have uncommited changes on your master branch" && exit 1; fi
	git branch -D production
	git checkout -b production
	git push -f --set-upstream origin production
	git checkout master
	@echo "You branch will be tested on CI and once all tests are successfully finished production docker image will be build"

docker-build:
	docker build --tag $(NAME):$(BRANCH) --build-arg BRANCH=$(BRANCH) ./
	docker tag $(NAME):$(BRANCH) $(NAME):$(VERSION)

docker-push: docker-build
	docker tag $(NAME):$(VERSION) $(REGISTRY_USER)/$(NAME):$(VERSION)
	docker tag $(NAME):$(BRANCH) $(REGISTRY_USER)/$(NAME):$(BRANCH)
	docker push $(REGISTRY_USER)/$(NAME):$(BRANCH)
	docker push $(REGISTRY_USER)/$(NAME):$(VERSION)
