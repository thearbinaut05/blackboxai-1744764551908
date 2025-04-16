import pytest
from unittest.mock import patch, MagicMock
from src.core.quantum_engine import QuantumEngine, QuantumEngineError
import numpy as np

class TestQuantumEngine:
    @pytest.fixture
    def engine(self):
        return QuantumEngine()

    def test_optimize_portfolio_quantum_success(self, engine):
        """Test successful quantum portfolio optimization"""
        assets = ['AAPL', 'GOOG', 'TSLA']
        
        with patch('qiskit.execute') as mock_execute:
            # Mock quantum execution results
            mock_result = MagicMock()
            mock_result.get_counts.return_value = {'001': 512, '010': 256, '100': 256}
            mock_execute.return_value.result.return_value = mock_result
            
            weights, return_rate = engine.optimize_portfolio(assets)
            
            assert len(weights) == len(assets)
            assert sum(weights) == pytest.approx(1.0)
            assert 0 <= return_rate <= 1

    def test_optimize_portfolio_classical_fallback(self, engine):
        """Test classical fallback when quantum fails"""
        assets = ['AAPL', 'GOOG', 'TSLA']
        
        with patch('qiskit.execute', side_effect=Exception('Quantum error')):
            weights, return_rate = engine.optimize_portfolio(assets)
            
            assert len(weights) == len(assets)
            assert sum(weights) == pytest.approx(1.0)
            assert 0 <= return_rate <= 1

    def test_result_processing(self, engine):
        """Test quantum result processing logic"""
        test_counts = {
            '101': 400,  # 5 assets example
            '110': 300,
            '011': 300
        }
        
        weights, return_rate = engine._process_results(test_counts, 3)
        
        assert len(weights) == 3
        assert sum(weights) == pytest.approx(1.0)
        assert return_rate == pytest.approx(0.4)

    def test_invalid_risk_factor(self, engine):
        """Test invalid risk factor handling"""
        with pytest.raises(ValueError):
            engine.optimize_portfolio(['AAPL'], risk_factor=-0.1)
        
        with pytest.raises(ValueError):
            engine.optimize_portfolio(['AAPL'], risk_factor=1.1)

@pytest.fixture
def classical_fallback():
    from src.core.quantum_engine import ClassicalFallback
    return ClassicalFallback()

class TestClassicalFallback:
    def test_fallback_weights(self, classical_fallback):
        weights, _ = classical_fallback.optimize_portfolio(['AAPL', 'MSFT'], 0.5)
        assert len(weights) == 2
        assert sum(weights) == pytest.approx(1.0)