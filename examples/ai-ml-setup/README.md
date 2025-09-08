# AI/ML Project Setup Example

This example shows how to set up the Claude Session Management System for a machine learning project with Python, TensorFlow, and FastAPI.

## Project Setup

### Before Setup
```
ml-recommendation-engine/
├── data/
├── notebooks/
├── requirements.txt
└── README.md
```

### After Setup
```
ml-recommendation-engine/
├── .claude/
│   ├── agents/
│   │   ├── main-agent-project-manager.md
│   │   ├── ai-engineer.md
│   │   ├── data-engineer.md
│   │   ├── code-reviewer.md
│   │   ├── testing-specialist.md
│   │   └── deployment-engineer.md
│   ├── commands/
│   ├── system/
│   └── sessions/
├── CLAUDE.md
├── data/
├── notebooks/
├── src/
├── tests/
├── docker/
├── requirements.txt
└── README.md
```

## Configuration Example

### CLAUDE.md (After Customization)
```markdown
# ML Recommendation Engine - Project Status

## Current Session Status
- **Last Updated**: 2024-09-08 (Session 1)
- **Project Status**: 15% Complete (2/7 stages done)
- **Active Stage**: Model Development & Training
- **Tech Stack**: Python 3.11, TensorFlow 2.14, FastAPI, Docker

## Development Status

### ✅ COMPLETED STAGES (2/7)
1. **Data Collection & Exploration** ✅ - Dataset acquired, EDA completed
2. **Model Development & Training** ✅ - Baseline model trained and evaluated

### 🔄 IN PROGRESS (1/7)
3. **Model Evaluation & Validation** 🔄 - Cross-validation and hyperparameter tuning

### ⏳ PENDING (4/7)
4. **API Development** ⏳ - FastAPI service for model serving
5. **Testing & Quality Assurance** ⏳ - Model and API testing
6. **Model Deployment** ⏳ - Containerization and cloud deployment
7. **Monitoring & Maintenance** ⏳ - Model performance monitoring
```

## Agent Configuration

### AI Engineer Agent
```markdown
# Core Responsibilities
- **Model Development**: TensorFlow/PyTorch model architecture and training
- **Data Processing**: Feature engineering and data pipeline optimization
- **ML Pipeline**: Training pipelines, experiment tracking, model evaluation
- **Performance Optimization**: Model inference speed and accuracy improvements
```

### Data Engineer Agent
```markdown
# Delegation Triggers
- Data pipeline architecture and ETL development
- Data quality and validation systems implementation
- Real-time data processing or streaming architectures required
- Database performance optimization for ML workloads
```

## Session Flow Example

### Session Start with `/ready`
```
🤖 Main Project Manager Agent Ready

Available Specialist Agents:
- ai-engineer: ML model development, training pipelines, inference optimization
- data-engineer: Data pipeline architecture, ETL processes, data quality
- code-reviewer: ML code quality, model validation, performance analysis
- testing-specialist: Model testing, API testing, ML pipeline validation
- deployment-engineer: ML model deployment, containerization, MLOps

Current Project Context:
- Project Type: AI/ML Project
- Technology Stack: Python, TensorFlow, FastAPI, Docker
- Current Stage: Model Evaluation & Validation
- ML Framework: TensorFlow 2.14 with Keras API
```

### Work Session
```
User: "The recommendation model accuracy is only 72%. I need to improve it and set up proper evaluation."

Main Agent: I'll coordinate model improvement with the AI engineer and 
establish comprehensive evaluation with the testing specialist.

[Delegates to ai-engineer for model architecture optimization]
[Coordinates with data-engineer for feature engineering improvements]
[Tasks testing-specialist with ML-specific validation framework]
[Reviews with code-reviewer for model performance and code quality]
```

### Session End with `/recap`
```
Session 3 Achievements (2024-09-08):
✅ Model Improvement: Accuracy increased from 72% to 87% through ensemble methods
✅ Evaluation Framework: Comprehensive cross-validation and metric tracking setup
✅ Feature Engineering: New user behavior features improved model performance

Session 3 Technical Framework:
- Model Architecture: Random Forest + Neural Network ensemble approach
- Evaluation Metrics: Precision@K, Recall@K, NDCG for ranking quality
- MLflow Integration: Experiment tracking and model versioning

Session 3 Lessons Learned:
✅ Effective Pattern: AI Engineer → Data Engineer collaboration improved features
✅ Technical Insight: Ensemble methods significantly outperformed single models
⚠️ Challenge Resolved: Memory issues with large datasets solved through batch processing
```

## Quality Gates Example

### AI Engineer Model Validation
```markdown
**Model Performance Standards Met:**
- ✅ Accuracy >85% on validation set
- ✅ Inference latency <50ms for real-time recommendations
- ✅ Model interpretability with SHAP values
- ✅ Bias testing across user demographics
- ✅ Memory usage optimized for production constraints
```

### Testing Specialist ML Testing
```markdown
**ML Testing Coverage:**
- Model Tests: Unit tests for model components, integration tests for pipeline
- Data Tests: Schema validation, distribution drift detection
- Performance Tests: Load testing for API endpoints, memory profiling
- A/B Testing: Framework for model comparison in production
- Regression Tests: Model performance regression detection
```

### Code Reviewer ML Code Quality
```markdown
**ML Code Quality Standards:**
- ✅ Reproducible experiments with fixed seeds
- ✅ Proper error handling in data processing
- ✅ Model versioning and artifact management
- ✅ Code documentation for model decisions
- ✅ Security review for data handling
```

## Specialized ML Workflows

### Data Pipeline Development
```
User: "Need to process real-time user interaction data for model updates"

Main Agent → Data Engineer:
- Design streaming data pipeline with Kafka/Kinesis
- Implement real-time feature computation
- Set up data quality monitoring

Main Agent → AI Engineer:
- Design online learning pipeline
- Implement model update strategies
- Handle model versioning for A/B testing
```

### Model Deployment Pipeline
```
User: "Ready to deploy the recommendation model to production"

Main Agent → Deployment Engineer:
- Containerize model with Docker
- Set up Kubernetes deployment
- Configure auto-scaling and monitoring

Main Agent → AI Engineer:
- Optimize model for production inference
- Implement model serving API
- Set up model performance monitoring
```

## Advanced AI/ML Coordination

### Model Experimentation
```markdown
**Experiment Tracking Workflow:**
1. AI Engineer designs experiment
2. Data Engineer prepares datasets
3. AI Engineer runs experiments with MLflow tracking
4. Testing Specialist validates results
5. Code Reviewer ensures reproducibility
6. Main Agent coordinates next iteration
```

### Production Model Updates
```markdown
**Model Update Pipeline:**
1. AI Engineer trains updated model
2. Testing Specialist runs comprehensive validation
3. Deployment Engineer stages model update
4. Code Reviewer validates deployment safety
5. Monitoring confirms production performance
6. Data Engineer tracks data drift post-deployment
```

## Benefits for ML Projects

### Before Claude System
- Ad-hoc experimentation without systematic tracking
- Inconsistent model evaluation standards
- Manual coordination between data and ML teams
- Lost context around model decisions and trade-offs

### After Claude System
- **Systematic Experimentation**: Structured approach to model development
- **Quality Standards**: Consistent evaluation and validation processes
- **Cross-functional Coordination**: Smooth data/ML/ops collaboration
- **Knowledge Preservation**: Complete context for model decisions and evolution
- **Reproducible Research**: All experiments and decisions documented

## ML-Specific Metrics

### Model Development Velocity
- **Experiment Setup**: 10 minutes with agent coordination
- **Quality Gates**: Automated validation reduces debugging time
- **Knowledge Transfer**: ML decisions preserved across sessions
- **Deployment Speed**: Systematic deployment reduces production issues

### Model Quality Consistency
- **Evaluation Standards**: Consistent metrics across all models
- **Code Quality**: ML-specific quality gates for reproducibility
- **Performance Monitoring**: Systematic tracking of model degradation
- **Bias Detection**: Regular fairness and bias evaluation

This example demonstrates how the Claude Session Management System provides structure and quality control for the inherently experimental and iterative nature of ML development.