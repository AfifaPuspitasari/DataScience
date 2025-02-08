# Hybrid XGBoost and Rule-Based Model for Fault Detection

## 📖 Project Overview
This model was developed and adapted based on my understanding and modifications of the journal titled [“Hybrid Approach of XGBoost and Rule-based Model for Fault Detection and Severity Estimation in Spacecraft Propulsion System”](http://papers.phmsociety.org/index.php/phmap/article/view/3709). The original study achieved **99.94% accuracy** in their testing data and secured second place in the competition. My adaptation introduces several modifications to enhance the model’s performance.

---

## 📊 Results and Discussion

### **🔬 Differences from the Journal's Approach:**
- In the journal, test data was **directly validated** in the competition without conducting modeling for training data.
- **SMOTE** was **not applied** in their model, while in my approach:
  - **SMOTE was applied** to the training data to oversample minority classes (non-normal cases), as even after a **5× augmentation**, class imbalance persisted.
  - For the test data model, **XGBoost was used** with the same parameters as the training model but **without SMOTE** to align with the original model’s approach.

### **📈 Accuracy Comparison:**
- My model achieved **99.44% accuracy** on **fold 2**, but the overall k-fold average accuracy was **97.29%**.
- Lower accuracy compared to the journal is likely due to **manual parameter tuning** rather than **GridSearch** or other optimization methods.
- The **learning rate** was identified as a key factor influencing accuracy.
- The accuracy variance between folds was minimal, suggesting **model consistency**.

### **🔍 Feature Engineering & Regression Analysis:**
- **TSFRESH** was utilized for feature extraction, but further improvements can be made by selecting only relevant features to **reduce noise**.
- The polynomial regression coefficients differ from the journal due to differences in the **library implementation** affecting coefficient calculations.
- **Ratio-based features** were retained to assist regression model predictions.

### **🚧 Pending Implementations:**
- **Hard voting** for test data classification, as done in the journal, is **not yet implemented**.
- **Scoring matrices** from the journal were not implemented since they were specific to the competition.
- Additional **feature selection techniques** could be explored to improve model performance.

---

## 🛠 Technologies Used
- **XGBoost** for classification
- **SMOTE** for handling class imbalance
- **TSFRESH** for feature extraction
- **Polynomial regression** for coefficient prediction
- **Manual hyperparameter tuning** (future work: GridSearch/optimization)

---

## 📌 Future Improvements
- Implement **GridSearch or other tuning methods** to optimize parameters.
- Develop **feature selection techniques** to improve TSFRESH results.
- Implement **hard voting** for test data classification.
- Incorporate **scoring matrices** to better evaluate model performance.

---

