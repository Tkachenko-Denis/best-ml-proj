import pickle
from pathlib import Path

import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler


def load_dummy_data(n_samples: int = 1000, n_features: int = 10, random_state: int = 42):
    rng = np.random.RandomState(random_state)
    X = rng.randn(n_samples, n_features)
    y = (X[:, 0] + 0.5 * X[:, 1] > 0).astype(int)
    return X, y


def train_baseline_model():
    X, y = load_dummy_data()
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    model = Pipeline(
        steps=[
            ("scaler", StandardScaler()),
            ("clf", LogisticRegression(max_iter=1000)),
        ]
    )
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    print(f"Improved baseline accuracy (with scaling): {acc:.4f}")

    models_path = Path("models")
    models_path.mkdir(exist_ok=True)
    with open(models_path / "baseline_model.pkl", "wb") as f:
        pickle.dump(model, f)

    return acc


if __name__ == "__main__":
    train_baseline_model()
