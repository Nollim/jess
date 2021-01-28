include .project.env
-include .project.env.local

docker-compose = docker-compose -f config/docker_jh/docker-compose.yml

docker-compose-up:
	$(docker-compose) up -d --remove-orphans

docker-compose-down:
	$(docker-compose) down -v

docker-composer-rebuild: docker-compose-down docker-compose-up

docker-compose-config:
	$(docker-compose) config

install-from-configuration: docker-compose-up npm-install composer-install
	@make -s drush-si
	@make -s fix-permissions
	@make -s npm-install
	@make -s up

install-from-database: docker-compose-up composer-install
	$(docker-compose) exec mysql ./import-db.sh

composer-install:
	@make -s composer install
	@make -s composer site-prepare

gulp-build:
	@make -s npm CMD="install"
	$(docker-compose) run --rm node gulp build

npm:
	$(docker-compose) run --rm node npm ${CMD}

drush-si:
	@make -s drush "si -y -vv --site-name=$(SITE_NAME) --account-name=$(ACCOUNT_PASS) --account-pass=$(ACCOUNT_PASS) --config-dir=../config/dev"
	@make -s drush "si -y -vv --site-name=$(SITE_NAME) --account-name=$(ACCOUNT_PASS) --account-pass=$(ACCOUNT_PASS) --config-dir=../config/dev --db-url=mysql://$(SITE_NAME):$(SITE_NAME)@localhost:8080/$(SITE_NAME)"
	@make -s drush "it --choice=terms_import"
	@make -s drush "it --choice=group_importer"

fix-permissions:
	$(docker-compose) run --rm httpd /usr/local/apache2/htdocs/scripts/install/fix-permissions.sh --drupal_path=/usr/local/apache2/htdocs/web --drupal_user=user  --httpd_group=www-data

drush:
	@$(docker-compose) run --rm php ./bin/drush $(CMD)

drupal:
	@$(docker-compose) run --rm php ./bin/drupal $(CMD)

composer:
	$(docker-compose) run --rm php composer $(CMD)

phpcs-install-drupal-profiles:
	@$(docker-compose) run --rm php ./bin/phpcs \
	--config-set installed_paths ${PROJECT_ROOT}/web/vendor/drupal/coder/coder_sniffer

phpcs:
	@$(docker-compose) run --rm php ./bin/phpcs \
	--standard=Drupal \
	--ignore=bdt_migration_sandbox,icdc_architecture \
	web/modules/custom/$(CMD)

phpcbf:
	@$(docker-compose) run --rm php ./bin/phpcbf \
	--standard=DRUPAL \
	--ignore=bdt_migration_sandbox,icdc_architecture \
	web/modules/custom/${CMD}

drupal-bin:
	$(docker-compose) run --rm php ./bin/drupal $(CMD)

drupal-check:
	@$(docker-compose) run --rm php ./bin/drupal-check \
	web/modules/custom/$(CMD) \
	-ad

phpcs-practice:
	@$(PHPCS_BIN) \
	--standard=DRUPALPRACTICE \
	--ignore=bdt_migration_sandbox,icdc_architecture \
	${PROJECT_ROOT}/web/modules/custom/${CMD}

up:
	@git fetch --all
	@git rebase origin/develop
	@make gulp-build
	@make -s composer CMD="install"
	@make -s drush CMD="cr"
	@make -s drush CMD="updb -y"
	@make -s drush CMD="cim -y"
	@make drupal-bin CMD="smo dev"
	@make -s phpcs-install-drupal-profiles
