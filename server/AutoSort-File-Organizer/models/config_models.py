
from pydantic import BaseModel


class ExceptionsUpdate(BaseModel):
    exceptions: list[str]

class ConfigUpdate(BaseModel):
    source_folder: str | None = None
    destination_folder: str | None = None
    mode: str | None = None

class RulesUpdate(BaseModel): 
    rules: dict[str, list[str]] 
    

class RuleCategory(BaseModel): 
    category:  str 
  
class FullConfigUpdate(BaseModel):
    config: dict  
    
class WaitBeforeCopyUpdate(BaseModel):
    wait_before_copy: int

class VerifyDelayUpdate(BaseModel):
    verify_delay: int
    
class ManageDuplicatesUpdate(BaseModel): 
    merge_duplicates: bool