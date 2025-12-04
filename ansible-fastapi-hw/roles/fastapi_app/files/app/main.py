from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    """
    Root endpoint returning welcome message.
    
    Returns:
        Dictionary with welcome message
    """
    return {"message": "Hello, DevOps World!"}


@app.get("/health")
def health_check():
    """
    Health check endpoint for monitoring.
    
    Returns:
        Dictionary with status information
    """
    return {"status": "healthy", "service": "fastapi"}


@app.get("/info")
def get_info():
    """
    Application information endpoint.
    
    Returns:
        Dictionary with application metadata
    """
    return {
        "app": "FastAPI DevOps Demo",
        "version": "1.0.0",
        "framework": "FastAPI",
        "deployment": "Docker + Ansible"
    }
