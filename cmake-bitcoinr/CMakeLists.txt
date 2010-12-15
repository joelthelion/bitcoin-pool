
IF(WIN32)
	ADD_DEFINITIONS(-D__WXMSW__)
ENDIF(WIN32)

SET(BITCOIN_REMOTE_MINER_SRC
	${CMAKE_SOURCE_DIR}/src/remoteminermain.cpp
	${CMAKE_SOURCE_DIR}/src/cryptopp/cpu.cpp
	${CMAKE_SOURCE_DIR}/src/cryptopp/sha.cpp
	${CMAKE_SOURCE_DIR}/src/json/json_spirit_reader.cpp
	${CMAKE_SOURCE_DIR}/src/json/json_spirit_value.cpp
	${CMAKE_SOURCE_DIR}/src/json/json_spirit_writer.cpp
	${CMAKE_SOURCE_DIR}/src/remote/base64.c
	${CMAKE_SOURCE_DIR}/src/remote/remoteminerclient.cpp
	${CMAKE_SOURCE_DIR}/src/remote/remoteminermessage.cpp
	${CMAKE_SOURCE_DIR}/src/remote/remoteminerthreadcpu.cpp
)

SET(BITCOIN_REMOTE_MINER_CUDA_SRC
	${CMAKE_SOURCE_DIR}/src/remote/remoteminerthreadgpu.cpp
	${CMAKE_SOURCE_DIR}/src/remote/cuda/bitcoinminercuda.cpp
	${CMAKE_SOURCE_DIR}/src/remote/cuda/bitcoinminercuda.cu
)

SET(BITCOIN_REMOTE_MINER_OPENCL_SRC
	${CMAKE_SOURCE_DIR}/src/remote/remoteminerthreadgpu.cpp
	${CMAKE_SOURCE_DIR}/src/remote/opencl/bitcoinmineropencl.cpp
)


IF(BITCOIN_ENABLE_CUDA)
        ADD_DEFINITIONS(-D_BITCOIN_MINER_CUDA_)
	CUDA_ADD_EXECUTABLE(bitcoinr-cuda WIN32 ${BITCOIN_REMOTE_MINER_SRC} ${BITCOIN_REMOTE_MINER_CUDA_SRC})
        SET_TARGET_PROPERTIES(bitcoinr-cuda
                        PROPERTIES COMPILE_DEFINITIONS _BITCOIN_MINER_CUDA_)
	TARGET_LINK_LIBRARIES(bitcoinr-cuda ${CUDA_LIBRARIES})
        SET(BINARIES ${BINARIES} bitcoinr-cuda)
        REMOVE_DEFINITIONS(-D_BITCOIN_MINER_CUDA_)
ENDIF(BITCOIN_ENABLE_CUDA)

IF(BITCOIN_ENABLE_OPENCL)
        ADD_DEFINITIONS(-D_BITCOIN_MINER_OPENCL_)
        ADD_EXECUTABLE(bitcoinr-opencl ${BITCOIN_REMOTE_MINER_SRC} ${BITCOIN_REMOTE_MINER_OPENCL_SRC})
        SET_TARGET_PROPERTIES(bitcoinr-opencl
                        PROPERTIES COMPILE_DEFINITIONS _BITCOIN_MINER_OPENCL_)
	TARGET_LINK_LIBRARIES(bitcoinr-opencl ${OPENCL_LIBRARY})
        SET(BINARIES ${BINARIES} bitcoinr-opencl)
        REMOVE_DEFINITIONS(-D_BITCOIN_MINER_OPENCL_)
ENDIF(BITCOIN_ENABLE_OPENCL)

ADD_EXECUTABLE(bitcoinr-cpu ${BITCOIN_REMOTE_MINER_SRC})
SET(BINARIES ${BINARIES} bitcoinr-cpu)

FOREACH(binary ${BINARIES})
    TARGET_LINK_LIBRARIES(${binary} ${Boost_LIBRARIES} ${OPENSSL_LIBRARIES})
    IF(WIN32)
            TARGET_LINK_LIBRARIES(${binary} winmm.lib shlwapi.lib)
    ELSE(WIN32)
            TARGET_LINK_LIBRARIES(${binary} pthread)
    ENDIF(WIN32)
ENDFOREACH(binary)

