# ML103: Large Language Models on HPC Clusters

<div align="center">
  <img src="REANNZ_logo.png" alt="REANNZ Logo" width="200"/>
</div>

This repository contains comprehensive workshop materials for running Large Language Models (LLMs) on High Performance Computing (HPC) clusters. The workshop covers LLM inference, fine-tuning, and production deployment using GPU resources.

## Workshop Overview

This 3-4 hour hands-on workshop introduces participants to:

- **LLM Fundamentals**: Understanding model architectures and computational requirements
- **HPC Integration**: Leveraging GPU resources (L4, A100, H100) for LLM workloads
- **Local Inference**: Running models efficiently on L4 GPUs with memory optimization
- **Fine-tuning**: Implementing LoRA and QLoRA for efficient model adaptation
- **Production Deployment**: Building scalable LLM services using Slurm job scheduling

## Learning Objectives

By the end of this workshop, participants will be able to:

- Set up and configure LLM environments on HPC clusters
- Run local LLM inference with memory optimization techniques
- Fine-tune models using distributed training methods
- Deploy LLM services using Slurm job scheduling
- Optimize performance and resource utilization
- Monitor and scale LLM applications

## Workshop Structure

### 1. Introduction (30 minutes)
**Notebook**: `01_introduction.ipynb`
- LLM basics and HPC setup
- GPU resource types and capabilities
- Environment configuration
- Model size and memory requirements

### 2. Local LLM Inference (60 minutes)
**Notebook**: `02_local_llm.ipynb`
- Loading and running models on L4 GPUs
- Memory optimization techniques (quantization, flash attention)
- Interactive chat interfaces
- Batch processing for efficiency
- Performance monitoring and benchmarking

### 3. Fine-tuning (90 minutes)
**Notebook**: `03_fine_tuning.ipynb`
- Fine-tuning concepts and methods
- LoRA (Low-Rank Adaptation) implementation
- QLoRA for memory-efficient training
- Distributed training across multiple GPUs
- Model evaluation and comparison
- Deployment preparation

### 4. Production Deployment (60 minutes)
**Notebook**: `04_slurm_production.ipynb`
- Slurm job script creation and management
- Building LLM services and APIs
- Monitoring and logging setup
- Horizontal scaling strategies
- Load balancing and resource optimization

## Prerequisites

- Basic Python programming knowledge
- Familiarity with Jupyter notebooks
- Understanding of machine learning concepts
- Access to HPC cluster with GPU resources (L4, A100, or H100)

## Repository Structure

```
ml103_dev/
├── README.md                    # This file
├── LICENSE                      # MIT License
├── REANNZ_logo.png             # REANNZ logo
├── notebooks/                   # Workshop notebooks
│   ├── 01_introduction.ipynb    # LLM basics and HPC setup
│   ├── 02_local_llm.ipynb      # Local inference on L4 GPUs
│   ├── 03_fine_tuning.ipynb    # Fine-tuning with LoRA/QLoRA
│   └── 04_slurm_production.ipynb # Production deployment
├── examples/                    # Example scripts and configurations
└── scripts/                     # Utility scripts
```

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd ml103_dev
   ```

2. **Access HPC cluster** with GPU resources:
   - Request L4 GPU node for inference
   - Request A100/H100 for training (if available)

3. **Set up environment**:
   ```bash
   # Load required modules
   module load python/3.11
   module load cuda/12.0
   
   # Create virtual environment
   python -m venv llm_env
   source llm_env/bin/activate
   
   # Install dependencies
   pip install torch transformers accelerate bitsandbytes peft datasets
   ```

4. **Start with the introduction notebook**:
   ```bash
   jupyter notebook notebooks/01_introduction.ipynb
   ```

## GPU Resources

### L4 GPUs (Recommended for Workshop)
- **Memory**: 24GB VRAM
- **Use case**: Inference, small fine-tuning
- **Availability**: High
- **Models**: Up to 7B parameters (full precision), 13B+ (quantized)

### A100 GPUs
- **Memory**: 40GB or 80GB VRAM
- **Use case**: Large model training, multi-GPU setups
- **Availability**: Medium
- **Models**: Up to 30B+ parameters

### H100 GPUs
- **Memory**: 80GB VRAM
- **Use case**: Cutting-edge research, largest models
- **Availability**: Limited
- **Models**: Up to 65B+ parameters

## Key Technologies

- **PyTorch**: Deep learning framework
- **Transformers**: Hugging Face library for LLMs
- **PEFT**: Parameter-Efficient Fine-Tuning
- **LoRA/QLoRA**: Low-Rank Adaptation techniques
- **BitsAndBytes**: Quantization for memory efficiency
- **Slurm**: Job scheduling and resource management
- **FastAPI/Flask**: Web service frameworks

## Best Practices

- **Resource Management**: Always monitor GPU memory usage
- **Model Selection**: Choose models appropriate for your GPU memory
- **Batch Processing**: Process multiple requests together when possible
- **Caching**: Cache models and tokenizers to avoid reloading
- **Monitoring**: Track resource usage and performance metrics
- **Cleanup**: Always clear GPU memory when done

## Troubleshooting

### Common Issues
- **Out of Memory**: Reduce batch size, use quantization, or smaller models
- **Slow Loading**: Use model caching and optimized loading techniques
- **Poor Performance**: Check GPU utilization and memory allocation

### Getting Help
- Check the troubleshooting sections in each notebook
- Review GPU memory usage with provided monitoring tools
- Consult HPC cluster documentation for resource limits

## Contributing

This is a workshop repository. Contributions are welcome for:
- Additional examples and exercises
- Performance optimizations
- New model configurations
- Documentation improvements

Please follow standard git practices for commits and branches.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Hugging Face for the Transformers library
- Meta for open-source LLM models
- The HPC community for cluster resources and support