# best-ml-proj

Учебный проект по машинному обучению. Здесь реализована baseline-модель
классификации с использованием `scikit-learn`.

## Установка

```bash
git clone git@github.com:Tkachenko-Denis/best-ml-proj.git
cd best-ml-proj
```

###  При необходимости

```bash
pip install -r requirements.txt
```

## Запуск baseline-модели

```bash
python -m src.models.baseline
```

## Стратегия ветвления

В проекте используется GitHub Flow:

- Ветка `main` всегда содержит стабильную, готовую к релизу версию кода.
- Все новые фичи и изменения делаются в отдельных ветках от `main`
(например, `feat/add-feature-scaling`).
- Каждое изменение попадает в `main` только через Pull Request.
- Перед merge PR должен быть как минимум один успешный прогон тестов
и ручная проверка изменений.
- Релизы помечаются аннотированными тегами (`v0.1.0`, `v0.2.0` и т. д.) и
публикуются через GitHub Releases.
