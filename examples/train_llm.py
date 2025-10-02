"""
Example training script for LLM fine-tuning on HPC cluster.
"""
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    Trainer,
    DataCollatorForLanguageModeling
)
from datasets import load_dataset
import torch
from peft import prepare_model_for_kbit_training, LoraConfig, get_peft_model

def load_model_and_tokenizer(model_name):
    """Load base model and tokenizer."""
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        torch_dtype=torch.float16,
        device_map="auto"
    )
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    return model, tokenizer

def prepare_for_training(model):
    """Prepare model for LoRA fine-tuning."""
    model = prepare_model_for_kbit_training(model)
    config = LoraConfig(
        r=8,
        lora_alpha=32,
        target_modules=["query_key_value"],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM"
    )
    model = get_peft_model(model, config)
    return model

def main():
    # Configuration
    model_name = "microsoft/phi-2"
    output_dir = "./fine_tuned_model"
    
    # Load model and tokenizer
    model, tokenizer = load_model_and_tokenizer(model_name)
    model = prepare_for_training(model)
    
    # Training arguments
    training_args = TrainingArguments(
        output_dir=output_dir,
        num_train_epochs=3,
        per_device_train_batch_size=4,
        gradient_accumulation_steps=4,
        learning_rate=2e-4,
        fp16=True,
        save_steps=100,
        logging_steps=10,
        eval_steps=100,
    )
    
    # Initialize trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=None,  # Add your dataset here
        data_collator=DataCollatorForLanguageModeling(tokenizer, mlm=False)
    )
    
    # Start training
    trainer.train()
    
    # Save the model
    trainer.save_model()

if __name__ == "__main__":
    main()